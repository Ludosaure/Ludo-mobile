import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/invoice.dart';

class InvoicesList extends StatelessWidget {
  final List<Invoice> invoices;

  const InvoicesList({Key? key, required this.invoices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              "invoices".tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: invoices.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Invoice invoice = invoices[index];
                return _buildInvoiceCard(context, invoice);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, Invoice invoice) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          // TODO télécharger la facture
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          "download-invoice".tr(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Invoice invoice) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.0,
        ),
      ),
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildInvoiceDetails(context, invoice),
              const SizedBox(height: 10),
              _buildDownloadButton(context, invoice),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceDetails(BuildContext context, Invoice invoice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "invoice-number".tr(
            namedArgs: {
              "number": invoice.invoiceNumber.toString(),
            },
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildInvoicedAmount(context, invoice),
        const SizedBox(height: 10),
        Text(
          "Créée le : ${DateFormat('d MMMM yyyy', 'FR').format(invoice.createdAt)}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoicedAmount(BuildContext context, Invoice invoice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "invoice-amount".tr(),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          "${invoice.amount} €",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
