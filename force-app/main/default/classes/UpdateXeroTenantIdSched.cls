global class UpdateXeroTenantIdSched  implements Schedulable, Database.AllowsCallouts {
    global void execute(SchedulableContext sc) {
        updateTenantId();
    }

    public void updateTenantId() {
        GetXeroTenantId.getXeroTenantId();
    }
}