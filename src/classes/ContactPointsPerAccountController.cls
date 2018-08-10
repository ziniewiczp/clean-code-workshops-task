public class ContactPointsPerAccountController {

    private List<Account> accounts;
    private Map<Id, Decimal> pointsByAccount;

    public List<Account> getAccounts() {
        accounts = new List<Account>();
        
        accounts = [SELECT Name, (SELECT Points__c FROM Contacts)
                    FROM Account
                    WHERE Name LIKE '%Test%'];        
        
        return accounts;
	}
    
    public Map<Id, Decimal> getPointsByAccount() {
        pointsByAccount = new Map<Id, Decimal>();
        
        for(Account account : accounts) {
            Decimal points = 0;

            for(Contact contact : account.Contacts) {
                if(contact.Points__c != null) {
                    points += contact.Points__c;
                }
            }

            pointsByAccount.put(account.Id, points);
        }

        return pointsByAccount;
    }
}