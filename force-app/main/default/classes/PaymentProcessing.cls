public interface PaymentProcessing {
    Pagereference pay();
    boolean processRefund();
}