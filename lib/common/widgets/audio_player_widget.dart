import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dayuwen/common/color/color.dart';

/// 播放状态
enum PlayerState { stopped, playing, paused }

///
/// @name 音频播放组件
/// @description 
/// @author lca
/// @date 2019-10-25
///
class AudioPlayerWidget extends StatefulWidget {
  final String url;
  final bool isLocal;
  final PlayerMode mode;

  AudioPlayerWidget(
      {@required this.url,
        this.isLocal = false,
        this.mode = PlayerMode.MEDIA_PLAYER});

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerWidgetState(url, isLocal, mode);
  }
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  String url;
  bool isLocal;
  PlayerMode mode;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  _AudioPlayerWidgetState(this.url, this.isLocal, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 20)),
            IconButton(
                onPressed: _isPlaying ? null : () => _play(),
                iconSize: 30.0,
                icon: Icon(Icons.play_arrow),
                color: Colors.cyan),
            IconButton(
                onPressed: _isPlaying ? () => _pause() : null,
                iconSize: 30.0,
                icon: Icon(Icons.pause),
                color: Colors.cyan),
            IconButton(
                onPressed: _isPlaying || _isPaused ? () => _stop() : null,
                iconSize: 30.0,
                icon: Icon(Icons.stop),
                color: Colors.cyan),

            Padding(
              padding: EdgeInsets.only(right: 5,),
              child: Text(
                _position != null
                    ? '${_positionText ?? '00:00'} / ${_durationText ?? '00:00'}'
                    : _duration != null ? _durationText : '00:00/00:00',
                style: TextStyle(fontSize: 14.0,color: ETTColor.g4_color),
              ),
            ),
          ],
        ),

        Slider(
          onChanged: (v) {
            final position_ = v * _duration.inMilliseconds;
            _audioPlayer
                .seek(Duration(milliseconds: position_.round()));
          },
          value: (_position != null &&
              _duration != null &&
              _position.inMilliseconds > 0 &&
              _position.inMilliseconds < _duration.inMilliseconds)
              ? _position.inMilliseconds / _duration.inMilliseconds
              : 0.0,
        ),

      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((duration) => setState(() {
          _duration = duration;
        }));

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
          _onComplete();
          setState(() {
            _position = _duration;
          });
        });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
        _duration != null &&
        _position.inMilliseconds > 0 &&
        _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
    await _audioPlayer.play(url, isLocal: isLocal, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
