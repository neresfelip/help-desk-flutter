import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

class SobreNos extends StatefulWidget {
  const SobreNos({Key? key}) : super(key: key);

  @override
  State<SobreNos> createState() => _SobreNosState();
}

class _SobreNosState extends State<SobreNos> {

  String? versao;

  @override
  void initState() {
    super.initState();
    _getVersion().then((value) {setState(() {
      versao = value;
    });});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    'images/retangles.jpg',
                  ),
                  fit: orientation == Orientation.portrait ? BoxFit.fitHeight : BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                ),
              ),
              child: orientation == Orientation.portrait ? Column(
                children: [
                  Containers1(versao: versao),
                  const Containers2(),
                ],
              ) : Row(children: [Containers1(versao: versao),
                const Containers2(),],),
            );
          },
        ),
      ),
    );
  }

  Future<String> _getVersion() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;

  }

}

class Containers1 extends StatelessWidget {
  const Containers1({
    Key? key,
    required this.versao,
  }) : super(key: key);

  final String? versao;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Image(
                image: AssetImage('images/logo.png'),
                height: 200,
              ),
              Text(
                'Versão ${versao ?? '-'}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Containers2 extends StatelessWidget {
  const Containers2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Desenvolvido por Rede Industrial & SIGMA - Sistema Gerencial de Manutenção',
            textAlign: TextAlign.center,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Botao(
                    title: 'Visite nosso site',
                    icon: MaterialIcons.open_in_browser,
                    url: 'https://redeindustrial.com.br/',
                  ),
                  Botao(
                    title: 'Contate-nos',
                    icon: Icons.phone,
                    url: 'tel:1140620139',
                  ),
                ],
              ),
              Botao(title: 'sac@redeindustrial.com.br', icon: Icons.email_outlined, url: 'mailto:sac@redeindustrial.com.br'),
            ],
          ),
          Column(
            children: [
              Text('Nossas redes sociais'),
              Row(
                children: [
                  Botao2(
                    icon: FontAwesome.whatsapp,
                    url: 'whatsapp://send?phone=+5551980657000',
                    color: Colors.lightGreen,
                  ),
                  Botao2(
                    icon: FontAwesome.facebook,
                    url: 'fb://page/redeindustrial',
                    urlAlternativo:
                    'https://www.facebook.com/redeindustrial',
                    color: Colors.indigo,
                  ),
                  Botao2(
                    icon: FontAwesome.instagram,
                    url: 'https://www.instagram.com/redeindustrialoficial',
                    color: Colors.deepOrange,
                  ),
                  Botao2(
                    icon: FontAwesome.twitter,
                    url: 'https://twitter.com/industrial_rede',
                  ),
                  Botao2(
                    icon: FontAwesome.youtube_play,
                    url: 'https://www.youtube.com/user/suportesigmari',
                    color: Colors.red,
                  ),
                  Botao2(
                    icon: FontAwesome.linkedin,
                    url: 'https://www.linkedin.com/company/sigma---sistema-gerencial-de-manuten%C3%A7%C3%A3o/',
                    color: Colors.indigo,
                  ),
                ],
              ),
            ],
          ),
          Text('© 2021 | Todos os direitos reservados'),
        ],
      ),
    );
  }
}

launchURL(String url, String? urlAlternativo) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else if (urlAlternativo != null && await canLaunch(urlAlternativo)) {
    await launch(urlAlternativo);
  } else {
    throw 'Could not launch $url';
  }
}

class Botao extends StatelessWidget {
  Botao({required this.title, required this.icon, required this.url});

  String title;
  IconData icon;
  String url;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        launchURL(url, null);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(icon),
        ],
      ),
    );
  }

}

class Botao2 extends StatelessWidget {
  Botao2({required this.icon, required this.url, this.urlAlternativo, this.color});

  IconData icon;
  String url;
  String? urlAlternativo;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          launchURL(url, urlAlternativo);
        },
        child: Icon(icon, color: color,),
      ),
    );
  }
}
