@isTest
global class AddPointsToRelatedContactTests {


    @testSetup
    public static void setup() {
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
    }

    @isTest
    public static void testAddingPoints() {
        Contact contact = [SELECT Points__c FROM Contact WHERE LastName = 'TestContact0' LIMIT 1];
        System.assertEquals(null, contact.Points__c);

        Task task = new Task(
                OwnerId = UserInfo.getUserId(),
                Subject = 'Call',
                Status = 'In Progress',
                Priority = 'Normal',
                WhoId = contact.Id
        );
        insert task;

        contact = [SELECT Points__c FROM Contact WHERE LastName = 'TestContact0' LIMIT 1];
        System.assertEquals(5, contact.Points__c);
    }

    @isTest
    public static void testAddingDescription() {
        Contact contact = [SELECT Description FROM Contact WHERE LastName = 'TestContact0' LIMIT 1];
        System.assertEquals(null, contact.Description);

        List<Task> tasks = new List<Task>();
        for(Integer i = 0; i < 3; i++) {
            tasks.add(
                new Task(
                    OwnerId = UserInfo.getUserId(),
                    Subject = 'Call',
                    Status = 'In Progress',
                    Priority = 'Normal',
                    WhoId = contact.Id
                )
            );
        }
        insert tasks;

        contact = [SELECT Description FROM Contact WHERE LastName = 'TestContact0' LIMIT 1];
        System.assertEquals('This is VIP Contact.', contact.Description);
    }
}