class Weather {
  final double temperature;
  final double windSpeed;
  final int humidity;
  final double minTemp;
  final double maxTemp;
  final String city;
  final String description;
  final String localTime;
  final String icon;
  final String countryName;
  final List<ForecastDay> forecastDays;

  Weather({
    required this.temperature,
    required this.countryName,
    required this.windSpeed,
    required this.humidity,
    required this.minTemp,
    required this.maxTemp,
    required this.city,
    required this.localTime,
    required this.description,
    required this.icon,
    required this.forecastDays,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']?['name'] ?? 'Unknown City',
      countryName: json['location']?['country'] ?? 'Unknown Country',
      temperature:
          json['forecast']?['forecastday']?[0]?['day']?['avgtemp_c'] ?? 0.0,
      minTemp:
          json['forecast']?['forecastday']?[0]?['day']?['mintemp_c'] ?? 0.0,
      maxTemp:
          json['forecast']?['forecastday']?[0]?['day']?['maxtemp_c'] ?? 0.0,
      windSpeed: json['current']?['wind_mph'] ?? 0.0,
      humidity: json['current']?['humidity'] ?? 0,
      description: json['forecast']?['forecastday']?[0]?['day']?['condition']
              ?['text'] ??
          'No description',
      icon: json['forecast']?['forecastday']?[0]?['day']?['condition']
              ?['icon'] ??
          'https://cdn.pixabay.com/photo/2017/05/29/15/34/kitten-2354016_1280.jpg',
      localTime: json['location']?['localtime'] ?? '',
      forecastDays: (json['forecast']?['forecastday'] as List? ?? [])
          .map((day) => ForecastDay.fromJson(day))
          .toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final double avgTemp;
  final String icon;

  ForecastDay({required this.date, required this.avgTemp, required this.icon});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
        date: json['date'] ?? 'No date',
        avgTemp: json['day']?['avgtemp_c'] ?? 0.0,
        icon: json['day']?['condition']?['icon'] ??
            'https://cdn.pixabay.com/photo/2017/05/29/15/34/kitten-2354016_1280.jpg');
  }
}
