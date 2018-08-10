trigger AddPointsToRelatedContact on Task (before insert) {
    List<Contact> contactsToUpdate = new List<Contact>();

    for(Task task : Trigger.New) {
        if(task.WhoId != null) {
            Contact relatedContact = [SELECT Points__c, Description
                                      FROM Contact
                                      WHERE Id = :task.WhoId];

            for(Integer index = 0; index < contactsToUpdate.size(); index++) {
                if(contactsToUpdate.get(index).Id == relatedContact.Id) {
                     relatedContact = contactsToUpdate.remove(index);
                }
            }
            
            relatedContact.Points__c = (relatedContact.Points__c == null) ? 5 : relatedContact.Points__c + 5;

            if(relatedContact.Points__c > 10) {
                relatedContact.Description = 'This is VIP Contact.';
            }

            contactsToUpdate.add(relatedContact);
        }
    }

    update contactsToUpdate;
}