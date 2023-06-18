import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/invoice.dart';
import 'package:ludo_mobile/domain/use_cases/invoice/download_invoice_cubit.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
    return BlocConsumer<DownloadInvoiceCubit, DownloadInvoiceState>(
      builder: (BuildContext context, DownloadInvoiceState state) {
        if (state is DownloadInvoiceLoading) {
          return const CircularProgressIndicator();
        }
        return _buildButton(context, invoice);
      },
      listener: (BuildContext context, DownloadInvoiceState state) async {
        if (state is DownloadInvoiceSuccess) {
          if(!kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("download-invoice-success").tr(),
                backgroundColor: Colors.green,
              ),
            );
          }

        } else if (state is DownloadInvoiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(BuildContext context, Invoice invoice) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          context.read<DownloadInvoiceCubit>().downloadInvoice(
                invoice.id,
                invoice.invoiceNumber,
              );
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
      mainAxisAlignment: MainAxisAlignment.start,
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
          "Créée le : ${DateFormat(AppConstants.DATE_TIME_FORMAT_LONG).format(invoice.createdAt)}",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildInvoicedAmount(BuildContext context, Invoice invoice) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
