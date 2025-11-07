import 'package:flutter/material.dart';
import 'package:webview_all/webview_all.dart';

class PowerBIEmbedPage extends StatelessWidget {
  const PowerBIEmbedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Power BI report URL
    const powerBiUrl =
        'https://app.powerbi.com/reportEmbed?reportId=19adf48e-fef5-45d0-ab42-4676dbd188ae&autoAuth=true&ctid=ebc33efd-7258-4e11-8899-d85c565d0051';

    return  Container(
        height: 600,
        width: double.infinity,
      child: Webview(
          url: powerBiUrl,
        ),
    );
    
  }
}
