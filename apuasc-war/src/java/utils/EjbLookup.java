package utils;

import javax.naming.InitialContext;
import javax.naming.NamingException;

public final class EjbLookup {

    private static final String APP_NAME = "apuasc";
    private static final String EJB_MODULE = "apuasc-ejb";

    private EjbLookup() {
    }

    public static <T> T lookup(Class<T> type, String beanName) {
        String[] candidates = new String[] {
            "java:global/" + APP_NAME + "/" + EJB_MODULE + "/" + beanName,
            "java:global/" + APP_NAME + "/" + EJB_MODULE + "/" + beanName + "!" + type.getName(),
            "java:app/" + EJB_MODULE + "/" + beanName,
            "java:app/" + EJB_MODULE + "/" + beanName + "!" + type.getName(),
            "java:module/" + beanName,
            "java:module/" + beanName + "!" + type.getName()
        };

        NamingException lastError = null;
        for (String name : candidates) {
            try {
                Object obj = new InitialContext().lookup(name);
                return type.cast(obj);
            } catch (NamingException | ClassCastException ex) {
                if (ex instanceof NamingException) {
                    lastError = (NamingException) ex;
                }
            }
        }

        throw new IllegalStateException("Unable to lookup EJB for bean " + beanName, lastError);
    }
}
