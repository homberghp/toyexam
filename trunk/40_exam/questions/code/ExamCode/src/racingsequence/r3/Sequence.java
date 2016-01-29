package racingsequence.r3;

public class Sequence {
    private int value=0;
            
   public  int getNext(){
       synchronized (this) {
	   return value++;
       }
   }
}
