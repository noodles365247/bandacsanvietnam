package vn.edu.hcmute.springboot3_4_12.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;


public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter{


	@Override
	protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
		// Decorator mặc định cho user
		builder.addDecoratorPath("/*", "main-decorator.jsp");

		// Decorator cho admin
		builder.addDecoratorPath("/admin/*", "admin-decorator.jsp");

		// Decorator cho vendor
		builder.addDecoratorPath("/vendor/*", "vendor-decorator.jsp");
		
		// Exclude
		builder.addExcludedPath("/api/*");
		builder.addExcludedPath("/resources/*");
		builder.addExcludedPath("/static/*");
		builder.addExcludedPath("/login");
		builder.addExcludedPath("/register");
	}
}
