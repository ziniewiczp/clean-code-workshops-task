@isTest
global class ContactPointsPerAccountControllerTests {

    @testSetup
    private static void setup() {
        // create Accounts
        List<Account> accounts = new List<Account>();

        for(Integer i = 0; i < 3; i++) {
            accounts.add(new Account(Name = 'Test' + i));
        }
        insert accounts;

        // create Contacts related to created Accounts
        List<Contact> allContacts = new List<Contact>();

        for(Account account : [SELECT Id FROM Account]) {
            List<Contact> relatedContacts = new List<Contact>();

            for(Integer i = 0; i < 3; i++) {
                relatedContacts.add(new Contact(LastName = 'TestContact' + i, AccountId = account.Id));
            }
            allContacts.addAll(relatedContacts);
        }
        insert allContacts;

        // create Tasks to populate Contact's Points__c
        List<Task> tasks = new List<Task>();

        for(Contact contact : [SELECT LastName FROM Contact]) {
            tasks.add(new Task(
                OwnerId = UserInfo.getUserId(),
                Subject = 'Call',
                Status = 'In Progress',
                Priority = 'Normal',
                WhoId = contact.Id)
            );
        }
        insert tasks;
    }
    
    @isTest
    public static void testGetAccounts() {
        ContactPointsPerAccountController controller = new ContactPointsPerAccountController();
        List<Account> accounts = controller.getAccounts();

        System.assertEquals(3, accounts.size());
    }

    @isTest public static void testGetPointsByAccount() {
        ContactPointsPerAccountController controller = new ContactPointsPerAccountController();
        controller.getAccounts();
        Map<Id, Decimal> pointsByAccount = controller.getPointsByAccount();

        System.assertEquals(3, pointsByAccount.size());
        
        for(Decimal points : pointsByAccount.values()) {
            System.assertEquals(15, points);
        }
    }
}