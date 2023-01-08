import 'package:example/widgets/_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metaballs/metaballs.dart';

class ExportDialog extends StatefulWidget {
  const ExportDialog({
    super.key,
    required this.code,
  });

  final String code;

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Export Configuration',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                child: CodeRender(
                  code: widget.code,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: copyCode,
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      crossFadeState: copied ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: Row(
                        children: const [
                          Text('Copied'),
                          SizedBox(width: 5),
                          Icon(
                            Icons.check,
                            size: 16,
                          ),
                        ],
                      ),
                      secondChild: Row(
                        children: const [
                          Text('Copy'),
                          SizedBox(width: 5),
                          Icon(
                            Icons.copy_rounded,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void copyCode() {
    copied = true;
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {});
  }

  Widget get test => Metaballs(
        config: MetaballsConfig(
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0xff000000),
              Color(0xffffffff),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          bounceIntensity: 1,
          metaballs: 40,
          glowIntensity: 1,
          glowRadius: 1,
          radius: const Range(min: 25, max: 40),
          speed: const Range(min: 0.33, max: 1),
          effects: <MetaballsEffect>[
            MetaballsEffect.follow(),
          ],
        ),
      );
}
