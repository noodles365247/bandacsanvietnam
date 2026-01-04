package vn.edu.hcmute.springboot3_4_12.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;


public class CustomSiteMeshFilter extends ConfigurableSiteMeshFilter{


	@Override
	protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
		// Exclude - Các đường dẫn không áp dụng decorator
		builder.addExcludedPath("/api/*");
		builder.addExcludedPath("/resources/*");
		builder.addExcludedPath("/static/*");
		builder.addExcludedPath("/login");
		builder.addExcludedPath("/register");
		builder.addExcludedPath("/error");
		builder.addExcludedPath("/decorators/*");
		builder.addExcludedPath("/diagnosis/*");
		builder.addExcludedPath("/diagnosis/api/*");

		// Decorator cho admin - Ưu tiên trước
		builder.addDecoratorPath("/admin/*", "/decorators/admin-decorator.jsp");

		// Decorator cho vendor - Ưu tiên trước
		builder.addDecoratorPath("/vendor/*", "/decorators/vendor-decorator.jsp");

		// Decorator mặc định cho user - Áp dụng cuối cùng (catch-all)
		builder.addDecoratorPath("/*", "/decorators/main-decorator.jsp");
	}
}
