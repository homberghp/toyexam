package racingsequence.r4;

import net.jcip.annotations.GuardedBy;
import net.jcip.annotations.ThreadSafe;
@ThreadSafe
public class Sequence {
    @GuardedBy("this")
    private int value=0;

   public int getNext(){
       return value++;
   }
}
