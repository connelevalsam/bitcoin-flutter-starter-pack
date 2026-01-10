/*
* Created by Connel Asikong on 10/01/2026
*
*/

class Transaction {
  final String type;
  final String amount;
  final String usd;
  final String date;
  final String from;
  final String id;

  Transaction({
    required this.type,
    required this.amount,
    required this.usd,
    required this.date,
    required this.from,
    required this.id,
  });
}
