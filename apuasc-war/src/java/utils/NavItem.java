/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author pinju
 */
package utils;

public class NavItem {
    private String name;
    private String link;
    private String icon;      // Optional: for future icon support
    private String badge;     // Optional: for notification badges
    private String category;  // Optional: for grouping menu items

    // Constructor with required fields
    public NavItem(String name, String link) {
        this.name = name;
        this.link = link;
        this.icon = null;
        this.badge = null;
        this.category = null;
    }

    // Constructor with all fields
    public NavItem(String name, String link, String icon, String badge, String category) {
        this.name = name;
        this.link = link;
        this.icon = icon;
        this.badge = badge;
        this.category = category;
    }

    // Getters
    public String getName() {
        return name;
    }

    public String getLink() {
        return link;
    }

    public String getIcon() {
        return icon;
    }

    public String getBadge() {
        return badge;
    }

    public String getCategory() {
        return category;
    }
}