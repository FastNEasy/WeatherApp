import 'package:flutter/material.dart';
import 'package:weather_app/src/data_class/weather_data.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({this.weatherData, this.cityName, Key? key})
      : super(key: key);
  final Future<WeatherData>? weatherData;
  final String? cityName;
  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget>
    with SingleTickerProviderStateMixin {
  String? cityName;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  //helper class and provider class favorites
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
            begin: const Offset(-0.05, 0.0), end: const Offset(0.05, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<WeatherData>(
        future: widget.weatherData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      SlideTransition(
                        position: _offsetAnimation,
                        child: SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Image.network(
                            "https://openweathermap.org/img/wn/${snapshot.data?.current?.weather?.first.icon}@2x.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.cityName}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "${snapshot.data?.current?.weather?.first.description}",
                        style: TextStyle(fontSize: 32),
                      ),
                      Text(
                        "Temperature (C): ${snapshot.data?.current?.temp}",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Feels like (C): ${snapshot.data?.current?.feelsLike}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
