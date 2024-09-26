import 'package:flutter/material.dart';

class LoginExample extends StatelessWidget {
  const LoginExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                height: 100,
                child: Text(
                  'Example Login',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(
                        label: Text('Username'),
                      ),
                      onTapOutside: (_) => FocusScope.of(context).requestFocus(FocusNode()),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text('Password'),
                      ),
                      onTapOutside: (_) => FocusScope.of(context).requestFocus(FocusNode()),
                    ),
                    const SizedBox(height: 40),
                    FilledButton(
                      onPressed: () {},
                      child: const Text(
                        'Log in',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
