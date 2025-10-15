class Order {
  final int id;
  final String userName;
  final double totalPrice;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String addressLine;
  final String country;
  final String state;
  final String zipCode;
  final String cardName;
  final String cardNumber;
  final String expiration;
  final String cvv;
  final int paymentMethod;

  Order({
    required this.id,
    required this.userName,
    required this.totalPrice,
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.addressLine,
    required this.country,
    required this.state,
    required this.zipCode,
    required this.cardName,
    required this.cardNumber,
    required this.expiration,
    required this.cvv,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userName": userName,
      "totalPrice": totalPrice,
      "firstName": firstName,
      "lastName": lastName,
      "emailAddress": emailAddress,
      "addressLine": addressLine,
      "country": country,
      "state": state,
      "zipCode": zipCode,
      "cardName": cardName,
      "cardNumber": cardNumber,
      "expiration": expiration,
      "cvv": cvv,
      "paymentMethod": paymentMethod,
    };
  }
}
