import 'package:flutter/material.dart';

class ServicesCatalog extends StatelessWidget {
  const ServicesCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Text(
          'Услуги',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ServiceTile(
                name: 'ПЦР на COVID-19 (стандартный)',
                cost: 1800,
                processingTime: '2 дня',
              ),
              SizedBox(height: 16),
              ServiceTile(
                name: 'Анализ крови с формулой',
                cost: 690,
                processingTime: '1 день',
              ),
              SizedBox(height: 16),
              ServiceTile(
                name: 'Биохимия (базовая)',
                cost: 2440,
                processingTime: '1 день',
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String name;
  final int cost;
  final String processingTime;

  const ServiceTile({
    required this.name,
    required this.cost,
    required this.processingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 136,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    processingTime,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '$cost Р',
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Montserrat-Regular',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Добавить в корзину
                },
                child: Text(
                  'Добавить',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}