trigger AddPointsToRelatedContact on Task (before insert) {
    List<Contact> contactsToUpdate = new List<Contact>();

    for(Task task : Trigger.New) {
        if(task.WhoId != null) {
            Contact relatedContact = [SELECT Points__c, Description
                                      FROM Contact
                                      WHERE Id = :task.WhoId];
            
            if(relatedContact.Points__c == null) {
                relatedContact.Points__c = 5;
            } else {
                relatedContact.Points__c += 5;
            }

            if(relatedContact.Points__c > 10) {
                relatedContact.Description = 'This is VIP Contact.';
            }
            
            contactsToUpdate.add(relatedContact);
        }
    }

    update contactsToUpdate;
}