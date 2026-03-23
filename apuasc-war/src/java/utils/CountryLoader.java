package utils;

import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class CountryLoader {

    public static class Country {
        private String name;
        private String code;
        private String iso2;
        private String iso3;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
        }

        public String getIso2() {
            return iso2;
        }

        public void setIso2(String iso2) {
            this.iso2 = iso2;
        }

        public String getIso3() {
            return iso3;
        }

        public void setIso3(String iso3) {
            this.iso3 = iso3;
        }
    }

    public static List<Country> loadCountries() {
        List<Country> countries = new ArrayList<>();
        try {
            InputStream is = CountryLoader.class.getResourceAsStream("/resources/country_data.xml");
            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);
            NodeList items = doc.getElementsByTagName("item");

            for (int i = 0; i < items.getLength(); i++) {
                Element item = (Element) items.item(i);
                Country c = new Country();
                c.setName(item.getElementsByTagName("country").item(0).getTextContent());
                c.setCode(item.getElementsByTagName("countryCode").item(0).getTextContent());
                c.setIso2(item.getElementsByTagName("iso2").item(0).getTextContent());
                c.setIso3(item.getElementsByTagName("iso3").item(0).getTextContent());
                countries.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return countries;
    }
}
