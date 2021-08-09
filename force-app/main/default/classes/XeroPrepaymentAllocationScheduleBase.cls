global class XeroPrepaymentAllocationScheduleBase Implements Schedulable {
   public Interface IXeroPrepaymentAllocationScheduleBase {
       void execute(SchedulableContext sc);
   }

   global void execute(SchedulableContext sc) {
       Type targettype = Type.forName('XeroPrepaymentAllocationSchedule');
       if(targettype!=null){
         IXeroPrepaymentAllocationScheduleBase obj = (IXeroPrepaymentAllocationScheduleBase)targettype.NewInstance();
         obj.execute(sc);
       }
   }
}