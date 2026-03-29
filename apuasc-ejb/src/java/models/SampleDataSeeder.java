package models;

import jakarta.annotation.PostConstruct;
import jakarta.ejb.EJB;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Singleton
@Startup
public class SampleDataSeeder {

    private static final boolean ENABLE_SEEDER = false;

    @EJB
    private UsersEntityFacade userFacade;

    @PostConstruct
    public void init() {
        if (!ENABLE_SEEDER) {
            return;
        }

        seedUser("Manager User", "manager@autofix.com", "Manager123!", "manager", "0123456793", 1, 0);
        seedUser("PJ", "receptionist@autofix.com", "Reception123!", "receptionist", "0123456790", 0, 0);
        seedUser("Technician User", "technician@autofix.com", "Tech123!", "technician", "0123456792", 0, 0);
        seedUser("Customer User", "customer@email.com", "Customer123!", "customer", "0123456794", 0, 0);
    }

    private void seedUser(String name, String email, String password, String role, String phone,
            Integer managerAccess, Integer superAdmin) {
        UsersEntity user = userFacade.findByEmail(email);
        if (user == null) {
            user = new UsersEntity();
            user.setEmail(email);
        }

        user.setName(name);
        user.setPassword(hash(password));
        user.setGender("female");
        user.setIs_malaysian(1);
        user.setOrigin_country("Malaysia");
        user.setCountry_code(60);
        user.setPhone_number(phone);
        user.setIC_number_passportnumber("900101101010");
        user.setHome_address("Kuala Lumpur");
        user.setRole(role);
        user.setHave_Manager_access(managerAccess);
        user.setIs_Super_Admin(superAdmin);

        if (user.getId() == null) {
            userFacade.create(user);
        } else {
            userFacade.edit(user);
        }
    }

    private String hash(String raw) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(raw.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("Unable to hash seed password", e);
        }
    }
}
