public with sharing virtual class PageControllerBase {
    
  private ComponentControllerBase myComponentController;
    
  public virtual ComponentControllerBase getMyComponentController() {
    return myComponentController;
  }
  
  public virtual void setMyComponentController(ComponentControllerBase compController) {
    myComponentController = compController;
    myComponentController.setPageController(this);
  }

  public virtual void setComponentController(ComponentControllerBase compController) {
    myComponentController = compController;
  }
    
  public PageControllerBase getThis() {
    return this;
  }
    
}