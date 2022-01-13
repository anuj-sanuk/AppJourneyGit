public class checkString{
    
    public static void method(String str){
        
        String finalString;	
        
        if(!String.isBlank(str)){
            if(str.contains(' ')){
                finalString = str.subStringAfter(' ');
                system.debug('--if--');
            }
            else if(str.isAlphaNumeric() && str.length()==10){
                finalString = str.Substring(1);
                system.debug('--else if--');
            }
            else if(str.contains('-')){
                finalString = str.subStringAfter('-');
                system.debug('--else if 2--');
            }
            else{
                finalString = str;
                system.debug('--else--');
            }
        }
        system.debug(finalString);
    } 
}