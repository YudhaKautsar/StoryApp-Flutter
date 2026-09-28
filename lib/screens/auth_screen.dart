import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/session_controller.dart';
import '../core/story_api.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/language_selector.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({required this.api, required this.session, super.key});

  final StoryApi api;
  final SessionController session;

  @override
  Widget build(BuildContext context) {
    return _AuthForm(api: api, session: session, isRegister: false);
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({required this.api, required this.session, super.key});

  final StoryApi api;
  final SessionController session;

  @override
  Widget build(BuildContext context) {
    return _AuthForm(api: api, session: session, isRegister: true);
  }
}

class _AuthForm extends StatefulWidget {
  const _AuthForm({
    required this.api,
    required this.session,
    required this.isRegister,
  });

  final StoryApi api;
  final SessionController session;
  final bool isRegister;

  @override
  State<_AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<_AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      if (widget.isRegister) {
        await widget.api.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.accountCreated)),
        );
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/login');
        }
      } else {
        final result = await widget.api.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        await widget.session.saveSession(
          token: result.token,
          name: result.name,
        );
        if (!mounted) return;
        context.go('/stories');
      }
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.connectionError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = widget.isRegister;
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _BrandMark(),
                      LanguageSelector(session: widget.session),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Text(
                    isRegister ? strings.registerTitle : strings.loginTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF242A24),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRegister
                        ? strings.registerSubtitle
                        : strings.loginSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: const Color(0xFF6D716B)),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isRegister) ...[
                          _FieldLabel(strings.nameLabel),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: strings.nameHint,
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? strings.nameRequired
                                : null,
                          ),
                          const SizedBox(height: 18),
                        ],
                        _FieldLabel(strings.emailLabel),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            hintText: strings.emailHint,
                          ),
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty || !email.contains('@')) {
                              return strings.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        _FieldLabel(strings.passwordLabel),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: isRegister
                              ? const [AutofillHints.newPassword]
                              : const [AutofillHints.password],
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: strings.passwordHint,
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? strings.showPassword
                                  : strings.hidePassword,
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) => (value?.length ?? 0) < 8
                              ? strings.passwordTooShort
                              : null,
                        ),
                        const SizedBox(height: 26),
                        FilledButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: const Color(0xFFB9513C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isRegister
                                      ? strings.createAccount
                                      : strings.signIn,
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              if (isRegister) {
                                if (context.canPop()) {
                                  context.pop();
                                } else {
                                  context.go('/login');
                                }
                              } else {
                                context.push('/register');
                              }
                            },
                      child: Text(
                        isRegister
                            ? strings.switchToLogin
                            : strings.switchToRegister,
                        style: const TextStyle(color: Color(0xFF355C4A)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF355C4A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.auto_stories_rounded, color: Colors.white),
        ),
        const SizedBox(width: 11),
        Text(
          AppLocalizations.of(context)!.brandName,
          style: TextStyle(
            color: Color(0xFF242A24),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF353A34),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
