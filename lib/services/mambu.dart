import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:requests/requests.dart';

class MambuService {
  var mambuUser = DotEnv().env['mambu_username'];
  var mambuPass = DotEnv().env['mambu_password'];
  var mambuMainAcc = DotEnv().env['mambu_main_checking_account'];
  var mambuClientId = DotEnv().env['mambu_client_id'];

  Future getMambuCurrentAccount() async {
    var req = await Requests.get(
        'https://${mambuUser.toString()}:${mambuPass.toString()}@razerhackathon.sandbox.mambu.com/api/savings/${mambuMainAcc.toString()}/');
    return req.json();
  }

  Future createSavingGoalsAccount(String mambuClientId) async {
    var req = await Requests.post(
        'https://${mambuUser.toString()}:${mambuPass.toString()}@razerhackathon.sandbox.mambu.com/api/savings',
        body: {
          "savingsAccount": {
            "name": "Digital Account",
            "accountHolderType": "CLIENT",
            "accountHolderKey": mambuClientId,
            "accountState": "APPROVED",
            "productTypeKey": "8a8e878471bf59cf0171bf6979700440",
            "accountType": "CURRENT_ACCOUNT",
            "currencyCode": "SGD",
            "allowOverdraft": "true",
            "overdraftLimit": "0",
            "interestSettings": {"interestRate": "1.25"}
          }
        },bodyEncoding: RequestBodyEncoding.JSON);
    return req.json();
  }

  Future getSavingGoalsTotal() async {
    var req = await Requests.get('https://razerhackathon.sandbox.mambu.com/api/clients/${mambuClientId.toString()}/savings');

  
  }
}
