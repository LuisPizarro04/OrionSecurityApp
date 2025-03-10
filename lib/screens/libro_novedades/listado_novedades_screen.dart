import 'package:flutter/material.dart';
import '../../services/novedades_service.dart';
import '../../models/novedad.dart';
import 'detalle_novedad_screen.dart';

class NovedadesDiariasScreen extends StatefulWidget {
  @override
  _NovedadesDiariasScreenState createState() => _NovedadesDiariasScreenState();
}

class _NovedadesDiariasScreenState extends State<NovedadesDiariasScreen> {
  final NovedadesService _novedadesService = NovedadesService();
  late Future<List<NovedadDiaria>> _novedadesDiarias;

  @override
  void initState() {
    super.initState();
    _cargarNovedades();
  }

  void _cargarNovedades() {
    setState(() {
      _novedadesDiarias = _novedadesService.obtenerNovedadesDiarias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novedades Diarias"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _cargarNovedades,
          ),
        ],
      ),
      body: FutureBuilder<List<NovedadDiaria>>(
        future: _novedadesDiarias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error al cargar novedades"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No hay novedades diarias registradas."));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final novedad = snapshot.data![index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetalleNovedadScreen(novedad: novedad)),
                    );
                  },
                  title: Text(novedad.titulo),
                  subtitle: Text(novedad.descripcion),
                  trailing: Text(novedad.fecha.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}