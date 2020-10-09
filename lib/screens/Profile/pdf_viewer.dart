import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfViewer extends StatefulWidget {
  PdfViewer(this.pdfUrl);
  final String pdfUrl;
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = true;
  PDFDocument document;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.pdfUrl);
    loadPdf();

  }

  loadPdf() async{
    setState(() => _isLoading = true);
   document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() => _isLoading = false);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("View Certificate"),
        centerTitle: true,
      ),

      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          zoomSteps: 1,

        ),
      ),
    );

  }
}
