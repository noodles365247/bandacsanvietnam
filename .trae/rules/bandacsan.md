PROJECT: Website quảng bá & kinh doanh đặc sản quê hương

1. Core Stack & Versions
- Backend: Spring Boot (MVC), Spring Data JPA
- Security: Spring Security + JWT
- Frontend: JSP + ONE CSS framework only (Bootstrap OR Tailwind OR Antd)
- Layout: SiteMesh 3
- Database: MySQL (primary)
- Realtime: WebSocket (Spring) / Socket
- Build: Maven

2. Architecture Rules
- Enforce 3-layer architecture: Controller → Service → Repository
- No business logic in Controller
- Entity ≠ DTO (must separate)
- Use enum for status fields (order, role, payment)

3. Security Rules
- All passwords MUST be hashed (BCrypt)
- Role-based authorization (Guest, User, Vendor, Admin, Shipper)
- JWT required for authenticated APIs
- No hard-coded secrets or tokens
- Validate input on server side (Bean Validation)

4. Feature Rules
- OTP via Email for register & reset password
- Cart must be persisted in database (no session-only cart)
- Order lifecycle must follow defined status flow
- Rating/comment only allowed for purchased products

5. Database Rules
- Use JPA relationships explicitly
- No direct SQL in Controller
- No auto-delete critical data (soft delete preferred)

6. Testing & Quality
- Manual test per role is mandatory
- Commit history must reflect feature ownership
- Code must be readable, no dead code

7. Prohibited
- Mixing multiple CSS frameworks
- Business logic in JSP
- Bypassing Spring Security
- Hardcoded admin accounts
