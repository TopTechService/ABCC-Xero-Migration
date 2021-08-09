public with sharing virtual class ComponentControllerBase {

  public PageControllerBase pageController { get; 
    set {
      if (value != null) {
	pageController = value;
	pageController.setComponentController(this);
      }
    }
  }
    
  public virtual void setPageController(PageControllerBase pController) {
    pageController = pController;
  } 
}