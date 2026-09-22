import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Session {
  static String? email;
  static List<String> roles = [];
}

void main() {
  ApiService.testConnection();

  runApp(const SkillLinkApp());
}

//==================== THEME ====================

class AppColors {
  static const Color primary = Color(0xFF1F3A5F);
  static const Color primaryDark = Color(0xFF13253D);
  static const Color secondary = Color(0xFF3D8BFF);
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1F29);
  static const Color textSecondary = Color(0xFF667085);

  static const Color success = Color(0xFF1F9254);
  static const Color warning = Color(0xFFC9962C);
  static const Color danger = Color(0xFFD1443A);
  static const Color info = Color(0xFF1F3A5F);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return success;
      case 'completed':
        return info;
      case 'rejected':
        return danger;
      case 'pending':
      default:
        return warning;
    }
  }
}

class SkillLinkApp extends StatelessWidget {
  const SkillLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillLink',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: baseScheme,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          color: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(
              color: AppColors.primary,
              width: 1.3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFEFF1F4),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.6,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.danger,
              width: 1.2,
            ),
          ),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
          ),
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          showUnselectedLabels: true,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE5E9F0),
          thickness: 1,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

//==================== Shared Small Widgets ====================

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}

//==================== Welcome Screen ====================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.4,
                          ),
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          color: Colors.white,
                          size: 46,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'SkillLink',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connect with Trusted\nLocal Service Providers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  28,
                  28,
                  28,
                  24,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Professional Help,\nJust a Tap Away',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Book verified electricians, plumbers, painters\nand more — all in one trusted platform.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: const [
                            _WelcomeStat(
                              value: '500+',
                              label: 'Professionals',
                            ),
                            _WelcomeStatDivider(),
                            _WelcomeStat(
                              value: '4.8★',
                              label: 'Avg. Rating',
                            ),
                            _WelcomeStatDivider(),
                            _WelcomeStat(
                              value: '10k+',
                              label: 'Bookings',
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(fontSize: 17),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Trusted by 500+ verified professionals',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeStat extends StatelessWidget {
  final String value;
  final String label;

  const _WelcomeStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WelcomeStatDivider extends StatelessWidget {
  const _WelcomeStatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: const Color(0xFFE1E5EB),
    );
  }
}

//==================== Login Screen ====================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter email and password.',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    final loginData =
        await ApiService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (loginData != null) {

      final String token =
          loginData['token'].toString();

      final List<dynamic> roles =
          loginData['roles'] as List<dynamic>;

      // ==========================================
      // SAVE LOGIN SESSION
      // ==========================================

      Session.email =
          emailController.text.trim();

      Session.roles = roles
          .map(
            (role) => role.toString(),
          )
          .toList();

      // ==========================================
      // SAVE EMAIL USING SHARED PREFERENCES
      // ==========================================

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'customerEmail',
        emailController.text.trim(),
      );

      // ==========================================
      // DEBUG
      // ==========================================

      print('TOKEN: $token');
      print('ROLES: $roles');
      print(
        'SESSION EMAIL: ${Session.email}',
      );
      print(
        'SESSION ROLES: ${Session.roles}',
      );
      print(
        'SAVED CUSTOMER EMAIL: '
        '${emailController.text.trim()}',
      );

      // ==========================================
      // CHOOSE ROLE
      // ==========================================

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChooseRoleScreen(
            name: '',
            email:
                emailController.text.trim(),
            password: '',
            phone: '',
            availableRoles: roles
                .map(
                  (role) => role.toString(),
                )
                .toList(),
            isLoginFlow: true,
          ),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid email or password.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24.0),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 20),

            // ==========================================
            // ICON
            // ==========================================

            Container(
              width: 84,
              height: 84,

              decoration: BoxDecoration(
                color:
                    AppColors.primary
                        .withOpacity(0.1),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.person_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // TITLE
            // ==========================================

            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.w800,
                color:
                    AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Login to continue using SkillLink',
              style: TextStyle(
                fontSize: 15,
                color:
                    AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 32),

            // ==========================================
            // EMAIL
            // ==========================================

            TextField(
              controller:
                  emailController,

              keyboardType:
                  TextInputType.emailAddress,

              decoration:
                  const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // PASSWORD
            // ==========================================

            TextField(
              controller:
                  passwordController,

              obscureText: true,

              decoration:
                  const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(
                  Icons.lock_outline,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ==========================================
            // LOGIN BUTTON
            // ==========================================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                    isLoading ? null : login,

                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // REGISTER
            // ==========================================

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RegisterScreen(),
                    ),
                  );
                },

                child: const Text(
                  "Don't have an account? Register",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
    
//==================== Register Screen ====================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void continueToRole() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields.'),
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseRoleScreen(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          phone: phoneController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add_rounded,
                size: 44,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Your Account',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Join SkillLink to get started',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: continueToRole,
                child: const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Login',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

//==================== Choose Role Screen ====================

class ChooseRoleScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;
  final List<String>? availableRoles;
  final bool isLoginFlow;

  const ChooseRoleScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.availableRoles,
    this.isLoginFlow = false,
  });

  @override
  State<ChooseRoleScreen> createState() =>
      _ChooseRoleScreenState();
}

class _ChooseRoleScreenState
    extends State<ChooseRoleScreen> {
  bool isLoading = false;

  Future<void> selectRole(String role) async {
    print('ROLE SELECTED: $role');
    print('LOGIN FLOW: ${widget.isLoginFlow}');
    print('AVAILABLE ROLES: ${widget.availableRoles}');

    // ================= LOGIN FLOW =================

    if (widget.isLoginFlow) {
      if (role == 'CUSTOMER') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const CustomerHomeScreen(),
          ),
        );
      } else if (role == 'PROVIDER') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProviderDashboardScreen(),
          ),
        );
      }

      return;
    }

    // ================= REGISTRATION FLOW =================

    setState(() {
      isLoading = true;
    });

    final success = await ApiService.registerUser(
      name: widget.name,
      email: widget.email,
      password: widget.password,
      phone: widget.phone,
      role: role,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    print('REGISTRATION SUCCESS: $success');

    if (success) {
      // IMPORTANT:
      Session.email = widget.email;
      Session.roles = [role];

      if (role == 'CUSTOMER') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const CustomerHomeScreen(),
          ),
        );
      } else if (role == 'PROVIDER') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const ProviderDashboardScreen(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration failed. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showCustomer =
        widget.availableRoles == null ||
            widget.availableRoles!.contains('CUSTOMER');

    final bool showProvider =
        widget.availableRoles == null ||
            widget.availableRoles!.contains('PROVIDER');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Role'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How do you want\nto use SkillLink?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose how you want to use SkillLink.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 36),

            if (showCustomer)
              _roleCard(
                context,
                icon: Icons.person_rounded,
                color: AppColors.primary,
                title: 'Customer',
                subtitle:
                    'Find & book trusted services near you',
                onTap: isLoading
                    ? () {}
                    : () => selectRole('CUSTOMER'),
              ),

            if (showCustomer && showProvider)
              const SizedBox(height: 18),

            if (showProvider)
              _roleCard(
                context,
                icon: Icons.handyman_rounded,
                color: AppColors.secondary,
                title: 'Service Provider',
                subtitle:
                    'Offer your skills and grow your business',
                onTap: isLoading
                    ? () {}
                    : () => selectRole('PROVIDER'),
              ),

            if (isLoading) ...[
              const SizedBox(height: 25),
              const Center(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text('Please wait...'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//------------------ProviderRequestScreen--------//
class ProviderRequestsScreen extends StatefulWidget {
  const ProviderRequestsScreen({super.key});

  @override
  State<ProviderRequestsScreen> createState() =>
      _ProviderRequestsScreenState();
}

class _ProviderRequestsScreenState
    extends State<ProviderRequestsScreen> {
  List<dynamic> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await ApiService.getProviderRequests(
      email: email,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      requests = result;
      isLoading = false;
    });
  }

  Future<void> updateStatus(
    int requestId,
    String status,
  ) async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      return;
    }

    final success =
        await ApiService.updateServiceRequestStatus(
      requestId: requestId,
      email: email,
      status: status,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'ACCEPTED'
                ? 'Service request accepted.'
                : 'Service request rejected.',
          ),
          backgroundColor: status == 'ACCEPTED'
          ? AppColors.success
          : Colors.red,
        ),
      );

      await loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update service request.',
          ),
        ),
      );
    }
  }

  String formatDate(String date) {
    final parts = date.split('-');

    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }

    return date;
  }

  String formatTime(String time) {
    try {
      final parts = time.split(':');

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Requests'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : requests.isEmpty
              ? const Center(
                  child: Text(
                    'No service requests available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadRequests,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: requests.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final request = requests[index];

                      final customer =
                          request['customer'];

                      final service =
                          request['service'];

                      final customerName =
                          customer?['name']?.toString() ??
                              'Unknown Customer';

                      final serviceName =
                          service?['name']?.toString() ??
                              'Unknown Service';

                      final date =
                          request['requestedDate']
                                  ?.toString() ??
                              '';

                      final time =
                          request['requestedTime']
                                  ?.toString() ??
                              '';

                      final address =
                          request['address']?.toString() ??
                              '';

                      final description =
                          request['description']
                                  ?.toString() ??
                              '';

                      final status =
                          request['status']?.toString() ??
                              'PENDING';

                      final requestId =
                          int.tryParse(
                        request['id'].toString(),
                      );

                      final displayStatus =
                          status.isNotEmpty
                              ? status[0].toUpperCase() +
                                  status
                                      .substring(1)
                                      .toLowerCase()
                              : 'Pending';

                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColors.primary
                                            .withOpacity(0.1),
                                    child: const Icon(
                                      Icons
                                          .person_rounded,
                                      color:
                                          AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 12),
                                  Expanded(
                                    child: Text(
                                      customerName,
                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                  ),
                                  StatusBadge(
                                    status:
                                        displayStatus,
                                  ),
                                ],
                              ),

                              const Divider(
                                height: 28,
                              ),

                              Text(
                                serviceName,
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors.primary,
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              _iconRow(
                                Icons
                                    .calendar_today_rounded,
                                formatDate(date),
                              ),

                              const SizedBox(
                                  height: 8),

                              _iconRow(
                                Icons
                                    .access_time_rounded,
                                formatTime(time),
                              ),

                              const SizedBox(
                                  height: 8),

                              _iconRow(
                                Icons
                                    .location_on_rounded,
                                address,
                              ),

                              const SizedBox(
                                  height: 12),

                              Text(
                                description,
                                style:
                                    const TextStyle(
                                  fontSize: 14,
                                  color: AppColors
                                      .textSecondary,
                                ),
                              ),

                              const SizedBox(
                                  height: 18),

                              if (status == 'PENDING')
                                Row(
                                  children: [
                                    Expanded(
                                      child:
                                          OutlinedButton.icon(
                                        onPressed:
                                            requestId ==
                                                    null
                                                ? null
                                                : () {
                                                    updateStatus(
                                                      requestId,
                                                      'REJECTED',
                                                    );
                                                  },
                                        icon: const Icon(
                                          Icons
                                              .close_rounded,
                                        ),
                                        label:
                                            const Text(
                                          'Reject',
                                        ),
                                        style:
                                            OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),      
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 12),
                                    Expanded(
                                      child:
                                          ElevatedButton
                                              .icon(
                                        onPressed:
                                            requestId ==
                                                    null
                                                ? null
                                                : () {
                                                    updateStatus(
                                                      requestId,
                                                      'ACCEPTED',
                                                    );
                                                  },
                                        icon: const Icon(
                                          Icons
                                              .check_rounded,
                                        ),
                                        label:
                                            const Text(
                                          'Accept',
                                        ),
                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              AppColors
                                                  .success,
                                          foregroundColor:
                                              Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _iconRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
//==================== Customer Home Screen ====================

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'name': 'Electrician',
        'icon': Icons.electrical_services_rounded,
        'color': const Color(0xFF2F6FED),
      },
      {
        'name': 'Plumber',
        'icon': Icons.plumbing_rounded,
        'color': const Color(0xFF17A2A0),
      },
      {
        'name': 'Carpenter',
        'icon': Icons.carpenter_rounded,
        'color': const Color(0xFFB5652C),
      },
      {
        'name': 'Mason',
        'icon': Icons.foundation_rounded,
        'color': const Color(0xFF6B7280),
      },
      {
        'name': 'Mechanic',
        'icon': Icons.car_repair_rounded,
        'color': const Color(0xFFE5484D),
      },
      {
        'name': 'AC Technician',
        'icon': Icons.ac_unit_rounded,
        'color': const Color(0xFF2CB1E8),
      },
      {
        'name': 'Computer Technician',
        'icon': Icons.computer_rounded,
        'color': const Color(0xFF7C5CFC),
      },
      {
        'name': 'Phone Repair',
        'icon': Icons.phone_android_rounded,
        'color': const Color(0xFF22A559),
      },
      {
        'name': 'Painter',
        'icon': Icons.format_paint_rounded,
        'color': const Color(0xFFFF8A3D),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillLink'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello! 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'What service do you need today?',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search for a service...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================== Become Provider Banner ====================

            Card(
              elevation: 0,
              color: AppColors.primary,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BecomeProviderScreen(),
                    ),
                  );
                },

                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Become a Service Provider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              'Offer your skills and earn through SkillLink',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 17,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            

            const SizedBox(height: 28),

            const SectionHeader(
              title: 'Service Categories',
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),

              itemCount: services.length,

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),

              itemBuilder: (context, index) {
                final service = services[index];

                final color =
                    service['color'] as Color;

                return Card(
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(16),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProviderListScreen(
                            serviceName:
                                service['name'] as String,
                          ),
                        ),
                      );
                    },

                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  color.withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),

                            child: Icon(
                              service['icon'] as IconData,
                              size: 26,
                              color: color,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            service['name'] as String,
                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              fontSize: 12.5,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ==================== Bottom Navigation ====================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CustomerBookingsScreen(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CustomerProfileScreen(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon:
                Icon(Icons.home_rounded),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.calendar_month_outlined),
            activeIcon:
                Icon(Icons.calendar_month_rounded),
            label: 'Bookings',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon:
                Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
//==================== Become Provider Screen ====================

class BecomeProviderScreen extends StatefulWidget {
  const BecomeProviderScreen({super.key});

  @override
  State<BecomeProviderScreen> createState() =>
      _BecomeProviderScreenState();
}

class _BecomeProviderScreenState
    extends State<BecomeProviderScreen> {

  bool isLoading = false;

  // ==================== Become Provider ====================

  Future<void> becomeProvider() async {
    final email = Session.email;

    // Check login session
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    // Already a provider
    if (Session.roles.contains('PROVIDER')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ProviderDashboardScreen(),
        ),
      );

      return;
    }

    // Start loading
    setState(() {
      isLoading = true;
    });

    // Call backend API
    final success = await ApiService.addRole(
      email: email,
      role: 'PROVIDER',
    );

    if (!mounted) return;

    // Stop loading
    setState(() {
      isLoading = false;
    });

    // ==================== Success ====================

    if (success) {
      // Add provider role to current session
      Session.roles.add('PROVIDER');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You are now a Service Provider!',
          ),
        ),
      );

      // Go to Provider Dashboard
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ProviderDashboardScreen(),
        ),
      );
    }

    // ==================== Failed ====================

    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not become a Service Provider.',
          ),
        ),
      );
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Become a Service Provider',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ==================== Icon ====================

            Container(
              width: 100,
              height: 100,

              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.handyman_rounded,
                size: 52,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 22),

            // ==================== Title ====================

            const Text(
              'Start Offering Your Skills',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            // ==================== Description ====================

            const Text(
              'Become a SkillLink service provider and connect with customers who need your skills.',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 30),

            // ==================== Info 1 ====================

            InfoTile(
              icon: Icons.people_alt_rounded,
              title: 'Reach Customers',
              subtitle:
                  'Connect with people looking for your services.',
            ),

            // ==================== Info 2 ====================

            InfoTile(
              icon: Icons.work_rounded,
              title: 'Show Your Skills',
              subtitle:
                  'Create your provider profile and list your services.',
              iconColor: AppColors.secondary,
            ),

            // ==================== Info 3 ====================

            InfoTile(
              icon: Icons.trending_up_rounded,
              title: 'Grow Your Business',
              subtitle:
                  'Receive service requests through SkillLink.',
              iconColor: AppColors.success,
            ),

            const SizedBox(height: 14),

            // ==================== Button ====================

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : becomeProvider,

                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.handyman_rounded,
                      ),

                label: Text(
                  isLoading
                      ? 'Becoming a Provider...'
                      : 'Become a Service Provider',

                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//==================== Provider List Screen ====================

class ProviderListScreen extends StatefulWidget {
  final String serviceName;

  const ProviderListScreen({
    super.key,
    required this.serviceName,
  });

  @override
  State<ProviderListScreen> createState() =>
      _ProviderListScreenState();
}

class _ProviderListScreenState
    extends State<ProviderListScreen> {
  List<dynamic> providers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProviders();
  }
  Future<void> loadProviders() async {
      final services =
          await ApiService.getServicesByCategory(
        widget.serviceName,
      );

      final List<dynamic> providerList = [];

      for (final service in services) {
        final provider = service['provider'];

        if (provider != null) {
          final providerId = provider['id'];

          final alreadyAdded = providerList.any(
            (item) => item['id'] == providerId,
          );

          if (!alreadyAdded) {
            providerList.add(provider);
          }
        }
      }

      if (!mounted) {
        return;
      }

      setState(() {
        providers = providerList;
        isLoading = false;
      });
    }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.serviceName} Providers'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : providers.isEmpty
              ? const Center(
                  child: Text(
                    'No providers found.',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];

                    return _providerCard(
                      context,
                      provider: provider,
                    );
                  },
                ),
    );
  }

  Widget _providerCard(
    BuildContext context, {
    required Map<String, dynamic> provider,
  }) {
    final name =
        provider['name']?.toString() ?? 'Unknown Provider';

    final phone =
        provider['phone']?.toString() ?? 'No phone number';

    final email =
        provider['email']?.toString() ?? 'No email';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final email = provider['email']?.toString();

          if (email == null || email.isEmpty) {
            return;
          }

          final profile =
              await ApiService.getProviderProfile(email);

          if (!context.mounted) {
            return;
          }

          if (profile == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Provider profile not found.',
                ),
              ),
            );

            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProviderProfileScreen(
                name: name,
                location:
                    profile['location']?.toString() ??
                        'Location not available',
                experience:
                    '${profile['experience']?.toString() ?? 'N/A'} years experience',
                rating: 'New',
                serviceName: widget.serviceName,
                description:
                  profile['description']?.toString() ??
                      'No description available',
                email: email,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    AppColors.primary.withOpacity(0.1),
                child: const Icon(
                  Icons.person_rounded,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      phone,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      email,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//==================== Provider Profile Screen ====================

class ProviderProfileScreen extends StatefulWidget {
  final String name;
  final String location;
  final String experience;
  final String rating;
  final String serviceName;
  final String description;
  final String email;

  const ProviderProfileScreen({
    super.key,
    required this.name,
    required this.location,
    required this.experience,
    required this.rating,
    required this.serviceName,
    required this.description,
    required this.email,
  });

  @override
  State<ProviderProfileScreen> createState() =>
      _ProviderProfileScreenState();
}

class _ProviderProfileScreenState
    extends State<ProviderProfileScreen> {

  List<dynamic> services = [];
  bool isLoadingServices = true;

  @override
  void initState() {
    super.initState();
    loadProviderServices();
  }

  Future<void> loadProviderServices() async {
    final result =
        await ApiService.getProviderServices(
      email: widget.email,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      services = result ?? [];
      isLoadingServices = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            // ==================== PROFILE ICON ====================

            CircleAvatar(
              radius: 55,
              backgroundColor:
                  AppColors.primary.withOpacity(0.1),

              child: const Icon(
                Icons.person_rounded,
                size: 58,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            // ==================== NAME ====================

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            // ==================== SERVICE CATEGORY ====================

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: Text(
                widget.serviceName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ==================== RATING ====================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warning,
                  size: 22,
                ),

                const SizedBox(width: 6),

                Text(
                  widget.rating,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ==================== LOCATION ====================

            InfoTile(
              icon: Icons.location_on_rounded,
              title: 'Location',
              subtitle: widget.location,
            ),

            // ==================== EXPERIENCE ====================

            InfoTile(
              icon: Icons.work_rounded,
              title: 'Experience',
              subtitle: widget.experience,
              iconColor: AppColors.secondary,
            ),

            // ==================== DESCRIPTION ====================

            InfoTile(
              icon: Icons.description_rounded,
              title: 'About',
              subtitle: widget.description,
              iconColor: AppColors.primary,
            ),

            const SizedBox(height: 20),

            // ==================== SERVICES ====================

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Services Offered',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (isLoadingServices)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              )
            else if (services.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No services available.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              Column(
                children: services.map((service) {

                  final serviceName =
                      service['name']?.toString() ??
                          'Service';

                  final category =
                      service['category']?.toString() ??
                          '';

                  final description =
                      service['description']?.toString() ??
                          '';

                  final price =
                      service['price']?.toString() ??
                          '0';

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            serviceName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  AppColors.textPrimary,
                            ),
                          ),

                          const SizedBox(height: 5),

                          if (category.isNotEmpty)
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 13,
                                color:
                                    AppColors.secondary,
                              ),
                            ),

                          if (description.isNotEmpty) ...[
                            const SizedBox(height: 8),

                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 13.5,
                                color:
                                    AppColors.textSecondary,
                              ),
                            ),
                          ],

                          const SizedBox(height: 10),

                          Text(
                            'Rs. $price',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // ==================== VERIFIED ====================

            InfoTile(
              icon: Icons.verified_rounded,
              title: 'Verified Provider',
              subtitle:
                  'Identity verification will be available later.',
              iconColor: AppColors.success,
            ),

            const SizedBox(height: 12),

            // ==================== REQUEST SERVICE ====================

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RequestServiceScreen(
                            providerName: widget.name,
                            serviceName: widget.serviceName,
                            customerEmail: Session.email ?? '',
                            providerEmail: widget.email,

                          ),
                    ),
                  );
                },

                child: const Text(
                  'Request Service',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==================== Request Service Screen ====================
class RequestServiceScreen extends StatefulWidget {
  final String providerName;
  final String serviceName;
  final String customerEmail;
  final String providerEmail;

  const RequestServiceScreen({
    super.key,
    required this.providerName,
    required this.serviceName,
    required this.customerEmail,
    required this.providerEmail,
  });

  @override
  State<RequestServiceScreen> createState() =>
      _RequestServiceScreenState();
}

class _RequestServiceScreenState
    extends State<RequestServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? pickedTime =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> submitRequest() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (selectedDate == null ||
      selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please select date and time.',
        ),
      ),
    );
    return;
  }

  final requestedDate =
      '${selectedDate!.year}-'
      '${selectedDate!.month.toString().padLeft(2, '0')}-'
      '${selectedDate!.day.toString().padLeft(2, '0')}';

  final requestedTime =
      '${selectedTime!.hour.toString().padLeft(2, '0')}:'
      '${selectedTime!.minute.toString().padLeft(2, '0')}';

  final services =
      await ApiService.getProviderServices(
    email: widget.providerEmail,
  );

  if (services == null || services.isEmpty) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No services found for this provider.',
        ),
      ),
    );

    return;
  }

  final matchingServices = services.where((service) {
    return service['category']?.toString() ==
        widget.serviceName;
  }).toList();

  if (matchingServices.isEmpty) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected service is not available.',
        ),
      ),
    );

    return;
  }

  final serviceId =
      int.tryParse(
        matchingServices.first['id'].toString(),
      );

  if (serviceId == null) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Invalid service.',
        ),
      ),
    );

    return;
  }

  final result =
      await ApiService.createServiceRequest(
    customerEmail: widget.customerEmail,
    providerEmail: widget.providerEmail,
    serviceId: serviceId,
    requestedDate: requestedDate,
    requestedTime: requestedTime,
    address: addressController.text.trim(),
    description:
        descriptionController.text.trim(),
  );

  if (!mounted) return;

  if (result != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Service request submitted successfully!',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Failed to submit service request.',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Service'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ==================== SERVICE DETAILS ====================

              const SectionHeader(
                title: 'Service Details',
              ),

              const SizedBox(height: 18),

              // ==================== PROVIDER ====================

              InfoTile(
                icon: Icons.person_rounded,
                title: 'Provider',
                subtitle: widget.providerName,
              ),

              // ==================== SERVICE ====================

              InfoTile(
                icon: Icons.build_rounded,
                title: 'Service',
                subtitle: widget.serviceName,
                iconColor: AppColors.secondary,
              ),

              const SizedBox(height: 12),

              // ==================== DATE ====================

              const Text(
                'Select Date',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: selectDate,

                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                  ),

                  label: Text(
                    selectedDate == null
                        ? 'Choose Date'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================== TIME ====================

              const Text(
                'Select Time',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton.icon(
                  onPressed: selectTime,

                  icon: const Icon(
                    Icons.access_time_rounded,
                    size: 18,
                  ),

                  label: Text(
                    selectedTime == null
                        ? 'Choose Time'
                        : selectedTime!.format(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ==================== ADDRESS ====================

              const Text(
                'Service Address',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: addressController,
                maxLines: 2,

                decoration: const InputDecoration(
                  hintText:
                      'Enter your service address',

                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your address';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ==================== PROBLEM ====================

              const Text(
                'Describe Your Problem',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    descriptionController,

                maxLines: 4,

                decoration: const InputDecoration(
                  hintText:
                      'Describe what service you need...',

                  prefixIcon: Icon(
                    Icons.description_outlined,
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please describe your problem';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // ==================== SUBMIT ====================

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton.icon(
                  onPressed: submitRequest,

                  icon: const Icon(
                    Icons.send_rounded,
                    size: 18,
                  ),

                  label: const Text(
                    'Submit Request',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

//==================== Provider Dashboard Screen ====================

class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  // ==================== Switch to Customer ====================

  Future<void> switchToCustomer(BuildContext context) async {
    final email = Session.email;

    // Check session
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    // Customer role already exists
    if (Session.roles.contains('CUSTOMER')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomerHomeScreen(),
        ),
      );

      return;
    }

    // Add CUSTOMER role
    final success = await ApiService.addRole(
      email: email,
      role: 'CUSTOMER',
    );

    if (!context.mounted) return;

    if (success) {
      // Update current session
      Session.roles.add('CUSTOMER');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can now use SkillLink as a Customer!',
          ),
        ),
      );

      // Go to Customer Home
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomerHomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not switch to Customer.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Welcome, Service Provider!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Manage your services and customer requests.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // ==================== My Profile ====================

            _dashboardTile(
              context,
              icon: Icons.person_rounded,
              color: AppColors.primary,
              title: 'My Profile',
              subtitle:
                  'View and edit your provider profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderProfileEditScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== My Services ====================

            _dashboardTile(
              context,
              icon: Icons.build_rounded,
              color: AppColors.secondary,
              title: 'My Services',
              subtitle:
                  'Manage the services you provide',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyServicesScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== Service Requests ====================

            _dashboardTile(
              context,
              icon: Icons.assignment_rounded,
              color: AppColors.warning,
              title: 'Service Requests',
              subtitle:
                  'View customer service requests',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderRequestsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== My Bookings ====================

            _dashboardTile(
              context,
              icon: Icons.calendar_month_rounded,
              color: AppColors.success,
              title: 'My Bookings',
              subtitle:
                  'View accepted and completed bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ProviderBookingsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ==================== Switch to Customer ====================

            _dashboardTile(
              context,
              icon: Icons.person_search_rounded,
              color: AppColors.primary,
              title: 'Switch to Customer',
              subtitle:
                  'Find and book services from other providers',
              onTap: () {
                switchToCustomer(context);
              },
            ),

            const SizedBox(height: 28),

            // ==================== Overview ====================

            const SectionHeader(
              title: 'Overview',
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon:
                        Icons.pending_actions_rounded,
                    title: 'Requests',
                    value: '0',
                    color: AppColors.warning,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon:
                        Icons.check_circle_rounded,
                    title: 'Completed',
                    value: '0',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    icon: Icons.star_rounded,
                    title: 'Rating',
                    value: '0.0',
                    color: AppColors.secondary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _statCard(
                    icon: Icons.people_rounded,
                    title: 'Customers',
                    value: '0',
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Dashboard Tile ====================

  Widget _dashboardTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,

                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 26,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color:
                            AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color:
                            AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== Stat Card ====================

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//==================== Provider Profile Edit Screen ====================

class ProviderProfileEditScreen extends StatefulWidget {
  const ProviderProfileEditScreen({super.key});

  @override
  State<ProviderProfileEditScreen> createState() =>
      _ProviderProfileEditScreenState();
}

class _ProviderProfileEditScreenState
    extends State<ProviderProfileEditScreen> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController experienceController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  bool isLoading = false;

  // ==================== Save Profile ====================

  Future<void> saveProfile() async {
    // Check session
    final email = Session.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    // Validate name
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your full name.',
          ),
        ),
      );

      return;
    }

    // Validate phone
    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your phone number.',
          ),
        ),
      );

      return;
    }

    // Validate location
    if (locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your location.',
          ),
        ),
      );

      return;
    }

    // Validate experience
    if (experienceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your years of experience.',
          ),
        ),
      );

      return;
    }

    final experience =
        int.tryParse(
          experienceController.text.trim(),
        );

    if (experience == null || experience < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid experience.',
          ),
        ),
      );

      return;
    }

    // Validate description
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a description about yourself.',
          ),
        ),
      );

      return;
    }

    // Start loading
    setState(() {
      isLoading = true;
    });

    // Call API
    final success =
        await ApiService.saveProviderProfile(
      email: email,
      location:
          locationController.text.trim(),
      experience: experience,
      description:
          descriptionController.text.trim(),
    );

    if (!mounted) return;

    // Stop loading
    setState(() {
      isLoading = false;
    });

    // ==================== Success ====================

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile saved successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }

    // ==================== Failed ====================

    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save profile. Please try again.',
          ),
        ),
      );
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Provider Profile',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // ==================== Profile Photo ====================

            Stack(
              children: [
                CircleAvatar(
                  radius: 55,

                  backgroundColor:
                      AppColors.primary
                          .withOpacity(0.1),

                  child: const Icon(
                    Icons.person_rounded,
                    size: 58,
                    color: AppColors.primary,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,

                  child: Container(
                    padding:
                        const EdgeInsets.all(6),

                    decoration:
                        const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextButton.icon(
              onPressed: () {},

              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 18,
              ),

              label: const Text(
                'Change Profile Photo',
              ),
            ),

            const SizedBox(height: 20),

            // ==================== Full Name ====================

            TextField(
              controller: nameController,

              decoration:
                  const InputDecoration(
                labelText: 'Full Name',
                hintText:
                    'Enter your full name',
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== Phone ====================

            TextField(
              controller: phoneController,

              keyboardType:
                  TextInputType.phone,

              decoration:
                  const InputDecoration(
                labelText: 'Phone Number',
                hintText:
                    'Enter your phone number',
                prefixIcon: Icon(
                  Icons.phone_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== Location ====================

            TextField(
              controller: locationController,

              decoration:
                  const InputDecoration(
                labelText: 'Location',
                hintText:
                    'Enter your location',
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== Experience ====================

            TextField(
              controller:
                  experienceController,

              keyboardType:
                  TextInputType.number,

              decoration:
                  const InputDecoration(
                labelText: 'Experience',
                hintText:
                    'Years of experience',
                prefixIcon: Icon(
                  Icons.work_outline,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ==================== About Me ====================

            TextField(
              controller:
                  descriptionController,

              maxLines: 4,

              decoration:
                  const InputDecoration(
                labelText: 'About Me',
                hintText:
                    'Tell customers about your experience and services...',
                prefixIcon: Icon(
                  Icons.description_outlined,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================== Save Button ====================

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : saveProfile,

                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.save_rounded,
                        size: 18,
                      ),

                label: Text(
                  isLoading
                      ? 'Saving Profile...'
                      : 'Save Profile',

                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Dispose ====================

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    experienceController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
//==================== My Services Screen ====================
class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() =>
      _MyServicesScreenState();
}

class _MyServicesScreenState
    extends State<MyServicesScreen> {
  List<dynamic> services = [];

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  // ============================================================
  // LOAD SERVICES
  // ============================================================

  Future<void> loadServices() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final result =
          await ApiService.getProviderServices(
        email: email,
      );

      if (!mounted) return;

      setState(() {
        services = result ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Load Services Error: $e');

      if (!mounted) return;

      setState(() {
        services = [];
        isLoading = false;
      });
    }
  }
  

  // ============================================================
  // SERVICE FORM DIALOG
  // ============================================================
Future<Map<String, dynamic>?> showServiceForm({
  Map<String, dynamic>? service,
}) async {
  final bool isEditing = service != null;

  final nameController = TextEditingController(
    text: isEditing
        ? service!['name']?.toString() ?? ''
        : '',
  );

  final descriptionController = TextEditingController(
    text: isEditing
        ? service!['description']?.toString() ?? ''
        : '',
  );

  final priceController = TextEditingController(
    text: isEditing
        ? service!['price']?.toString() ?? ''
        : '',
  );

  String selectedCategory = isEditing
      ? service!['category']?.toString() ?? 'Electrician'
      : 'Electrician';

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (
          dialogContext,
          setDialogState,
        ) {
          return AlertDialog(
            title: Text(
              isEditing
                  ? 'Edit Service'
                  : 'Add Service',
            ),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ==================== SERVICE NAME ====================

                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Service Name',
                      hintText: 'e.g. House Wiring',
                      prefixIcon: Icon(
                        Icons.build_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================== CATEGORY ====================

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(
                        Icons.category_outlined,
                      ),
                    ),
                    items: const [
                      'Electrician',
                      'Plumber',
                      'Carpenter',
                      'Mason',
                      'Mechanic',
                      'AC Technician',
                      'Computer Technician',
                      'Phone Repair',
                      'Painter',
                    ].map(
                      (category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================== DESCRIPTION ====================

                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe your service',
                      prefixIcon: Icon(
                        Icons.description_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ==================== PRICE ====================

                  TextField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter service price',
                      prefixIcon: Icon(
                        Icons.payments_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================== ACTIONS ====================

            actions: [

              // ==================== CANCEL ====================

              TextButton(
                onPressed: () async {
                  // Close keyboard
                  FocusManager.instance.primaryFocus?.unfocus();

                  // Give Android keyboard time to close
                  await Future.delayed(
                    const Duration(milliseconds: 300),
                  );

                  // Close dialog
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text(
                  'Cancel',
                ),
              ),

              // ==================== ADD / UPDATE ====================

              ElevatedButton(
                onPressed: () async {
                  final name =
                      nameController.text.trim();

                  final description =
                      descriptionController.text.trim();

                  final priceText =
                      priceController.text.trim();

                  // ==================== VALIDATION ====================

                  if (name.isEmpty ||
                      description.isEmpty ||
                      priceText.isEmpty) {
                    FocusManager.instance
                        .primaryFocus
                        ?.unfocus();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill all fields.',
                        ),
                      ),
                    );

                    return;
                  }

                  final price =
                      double.tryParse(priceText);

                  if (price == null || price < 0) {
                    FocusManager.instance
                        .primaryFocus
                        ?.unfocus();

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid price.',
                        ),
                      ),
                    );

                    return;
                  }

                  // ==================== CLOSE KEYBOARD ====================

                  FocusManager.instance
                      .primaryFocus
                      ?.unfocus();

                  // Give Android keyboard time to close
                  await Future.delayed(
                    const Duration(milliseconds: 300),
                  );

                  // ==================== CLOSE DIALOG ====================

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop({
                      'name': name,
                      'category': selectedCategory,
                      'description': description,
                      'price': price,
                    });
                  }
                },
                child: Text(
                  isEditing
                      ? 'Update'
                      : 'Add Service',
                ),
              ),
            ],
          );
        },
      );
    },
  );

  // ==================== DISPOSE CONTROLLERS ====================

  nameController.dispose();
  descriptionController.dispose();
  priceController.dispose();

  return result;
}


  // ============================================================
  // ADD SERVICE
  // ============================================================

  Future<void> addService() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    final data =
        await showServiceForm();

    if (data == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isSaving = true;
    });

    final success =
        await ApiService.addService(
      email: email,
      name: data['name'],
      category: data['category'],
      description: data['description'],
      price: data['price'],
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Service added successfully!',
          ),
          backgroundColor:
              AppColors.success,
        ),
      );

      await loadServices();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Could not add service.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // EDIT SERVICE
  // ============================================================
  Future<void> editService(
  Map<String, dynamic> service,
) async {
  final email = Session.email;

  if (email == null || email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'User session not found. Please login again.',
        ),
      ),
    );
    return;
  }

  final serviceId = int.tryParse(
    service['id'].toString(),
  );

  if (serviceId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid service ID.'),
      ),
    );
    return;
  }

  // Open edit form
  final data = await showServiceForm(
    service: service,
  );

  // User cancelled
  if (data == null) {
    return;
  }

  // Make sure screen is still active
  if (!mounted) {
    return;
  }

  print('EDIT: FORM CLOSED');
  print('EDIT: API CALL STARTED');

  setState(() {
    isSaving = true;
  });

  try {
    final success = await ApiService.updateService(
      id: serviceId,
      email: email,
      name: data['name'].toString(),
      category: data['category'].toString(),
      description: data['description'].toString(),
      price: (data['price'] as num).toDouble(),
    );

    print('EDIT: API CALL FINISHED - $success');

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Service updated successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      await loadServices();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not update service.',
          ),
        ),
      );
    }
  } catch (e) {
    print('EDIT ERROR: $e');

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Update error: $e',
        ),
      ),
    );
  }
}
  
  // ============================================================
  // DELETE SERVICE
  // ============================================================

  Future<void> deleteService(
      Map<String, dynamic> service) async {

    final email = Session.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'User session not found. Please login again.',
          ),
        ),
      );

      return;
    }

    final serviceId =
        int.tryParse(
      service['id'].toString(),
    );

    if (serviceId == null) {
      return;
    }

    final shouldDelete =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Service',
          ),
          content: Text(
            'Are you sure you want to delete '
            '"${service['name']}"?',
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isSaving = true;
    });

    final success =
        await ApiService.deleteService(
      id: serviceId,
      email: email,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Service deleted successfully!',
          ),
          backgroundColor:
              AppColors.success,
        ),
      );

      await loadServices();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Could not delete service.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Services',
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            isSaving ? null : addService,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Add Service',
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : services.isEmpty

              ? const Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons
                            .build_circle_outlined,
                        size: 70,
                        color:
                            AppColors
                                .textSecondary,
                      ),

                      SizedBox(
                        height: 16,
                      ),

                      Text(
                        'No services added yet.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      SizedBox(
                        height: 6,
                      ),

                      Text(
                        'Tap + Add Service to get started.',
                        style: TextStyle(
                          color:
                              AppColors
                                  .textSecondary,
                        ),
                      ),
                    ],
                  ),
                )

              : RefreshIndicator(
                  onRefresh:
                      loadServices,

                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    itemCount:
                        services.length,

                    itemBuilder:
                        (context, index) {

                      final service =
                          services[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 14,
                        ),

                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              // ==================== SERVICE INFO ====================

                              Row(
                                children: [

                                  Container(
                                    width: 48,
                                    height: 48,

                                    decoration:
                                        BoxDecoration(
                                      color: AppColors
                                          .primary
                                          .withOpacity(
                                        0.1,
                                      ),
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        12,
                                      ),
                                    ),

                                    child:
                                        const Icon(
                                      Icons
                                          .build_rounded,
                                      color:
                                          AppColors
                                              .primary,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  Expanded(
                                    child:
                                        Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,

                                      children: [

                                        Text(
                                          service[
                                                      'name']
                                                  ?.toString() ??
                                              '',
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                17,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          service[
                                                      'category']
                                                  ?.toString() ??
                                              '',
                                          style:
                                              const TextStyle(
                                            color:
                                                AppColors
                                                    .secondary,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    'Rs. ${service['price'] ?? 0}',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      fontSize:
                                          15,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 14,
                              ),

                              // ==================== DESCRIPTION ====================

                              Text(
                                service[
                                            'description']
                                        ?.toString() ??
                                    '',
                                style:
                                    const TextStyle(
                                  color:
                                      AppColors
                                          .textSecondary,
                                  height: 1.4,
                                ),
                              ),

                              const SizedBox(
                                height: 14,
                              ),

                              // ==================== BUTTONS ====================

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,

                                children: [

                                  OutlinedButton.icon(
                                    onPressed:
                                        isSaving
                                            ? null
                                            : () {
                                                editService(
                                                  service,
                                                );
                                              },
                                    icon:
                                        const Icon(
                                      Icons
                                          .edit_outlined,
                                      size: 18,
                                    ),
                                    label:
                                        const Text(
                                      'Edit',
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  OutlinedButton.icon(
                                    onPressed:
                                        isSaving
                                            ? null
                                            : () {
                                                deleteService(
                                                  service,
                                                );
                                              },
                                    icon:
                                        const Icon(
                                      Icons
                                          .delete_outline,
                                      size: 18,
                                    ),
                                    label:
                                        const Text(
                                      'Delete',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
//==================== Service Requests Screen ====================

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  State<ServiceRequestsScreen> createState() =>
      _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState
    extends State<ServiceRequestsScreen> {
  final List<Map<String, String>> requests = [
    {
      'customer': 'Kasun Perera',
      'service': 'Electrician',
      'date': '20/09/2026',
      'time': '10:00 AM',
      'address': 'Matara',
      'description':
          'Need to repair a damaged power socket.',
      'status': 'Pending',
    },
    {
      'customer': 'Nadeesha Silva',
      'service': 'AC Technician',
      'date': '21/09/2026',
      'time': '2:00 PM',
      'address': 'Galle',
      'description':
          'AC is not cooling properly.',
      'status': 'Pending',
    },
  ];

  void updateStatus(int index, String status) {
    setState(() {
      requests[index]['status'] = status;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request $status successfully.',
        ),
        backgroundColor:
            AppColors.statusColor(status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Requests'),
      ),
      body: requests.isEmpty
          ? const Center(
              child: Text(
                'No service requests available.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final request = requests[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  AppColors.primary
                                      .withOpacity(0.1),
                              child: const Icon(
                                Icons.person_rounded,
                                color:
                                    AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                request['customer']!,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors.textPrimary,
                                ),
                              ),
                            ),
                            StatusBadge(
                              status:
                                  request['status']!,
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        Text(
                          request['service']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _iconRow(
                          Icons.calendar_today_rounded,
                          request['date']!,
                        ),
                        const SizedBox(height: 8),
                        _iconRow(
                          Icons.access_time_rounded,
                          request['time']!,
                        ),
                        const SizedBox(height: 8),
                        _iconRow(
                          Icons.location_on_rounded,
                          request['address']!,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Problem Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color:
                                AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          request['description']!,
                          style: const TextStyle(
                            color:
                                AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (request['status'] ==
                            'Pending')
                          Row(
                            children: [
                              Expanded(
                                child:
                                    OutlinedButton.icon(
                                  style: OutlinedButton
                                      .styleFrom(
                                    foregroundColor:
                                        AppColors.danger,
                                    side:
                                        const BorderSide(
                                      color:
                                          AppColors.danger,
                                    ),
                                  ),
                                  onPressed: () =>
                                      updateStatus(
                                    index,
                                    'Rejected',
                                  ),
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Reject',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                    ElevatedButton.icon(
                                  style: ElevatedButton
                                      .styleFrom(
                                    backgroundColor:
                                        AppColors.success,
                                  ),
                                  onPressed: () =>
                                      updateStatus(
                                    index,
                                    'Accepted',
                                  ),
                                  icon: const Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'Accept',
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _iconRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

//==================== Provider Bookings Screen ====================
class ProviderBookingsScreen extends StatefulWidget {
  const ProviderBookingsScreen({super.key});

  @override
  State<ProviderBookingsScreen> createState() =>
      _ProviderBookingsScreenState();
}

class _ProviderBookingsScreenState
    extends State<ProviderBookingsScreen> {
  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result =
        await ApiService.getProviderBookings(
      email: email,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      bookings = result;
      isLoading = false;
    });
  }

  Future<void> completeBooking(
    int requestId,
  ) async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      return;
    }

    final success =
        await ApiService.updateServiceRequestStatus(
      requestId: requestId,
      email: email,
      status: 'COMPLETED',
    );

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Booking marked as completed.',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      await loadBookings();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to complete booking.',
          ),
        ),
      );
    }
  }

  String formatDate(String date) {
    final parts = date.split('-');

    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }

    return date;
  }

  String formatTime(String time) {
    try {
      final parts = time.split(':');

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period =
          hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookings.isEmpty
              ? const Center(
                  child: Text(
                    'No bookings available.',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadBookings,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    separatorBuilder:
                        (_, __) =>
                            const SizedBox(
                      height: 16,
                    ),
                    itemBuilder:
                        (context, index) {
                      final booking =
                          bookings[index];

                      final customer =
                          booking['customer'];

                      final service =
                          booking['service'];

                      final customerName =
                          customer?['name']
                                  ?.toString() ??
                              'Unknown Customer';

                      final serviceName =
                          service?['name']
                                  ?.toString() ??
                              'Unknown Service';

                      final date =
                          booking[
                                      'requestedDate']
                                  ?.toString() ??
                              '';

                      final time =
                          booking[
                                      'requestedTime']
                                  ?.toString() ??
                              '';

                      final address =
                          booking['address']
                                  ?.toString() ??
                              '';

                      final description =
                          booking['description']
                                  ?.toString() ??
                              '';

                      final status =
                          booking['status']
                                  ?.toString() ??
                              'ACCEPTED';

                      final requestId =
                          int.tryParse(
                        booking['id']
                            .toString(),
                      );

                      final displayStatus =
                          status.isNotEmpty
                              ? status[0]
                                      .toUpperCase() +
                                  status
                                      .substring(1)
                                      .toLowerCase()
                              : 'Accepted';

                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(
                            18,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColors
                                            .primary
                                            .withOpacity(
                                      0.1,
                                    ),
                                    child:
                                        const Icon(
                                      Icons
                                          .person_rounded,
                                      color: AppColors
                                          .primary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      customerName,
                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                  ),
                                  StatusBadge(
                                    status:
                                        displayStatus,
                                  ),
                                ],
                              ),

                              const Divider(
                                height: 28,
                              ),

                              Text(
                                serviceName,
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors.primary,
                                ),
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              _iconRow(
                                Icons
                                    .calendar_today_rounded,
                                formatDate(date),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              _iconRow(
                                Icons
                                    .access_time_rounded,
                                formatTime(time),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              _iconRow(
                                Icons
                                    .location_on_rounded,
                                address,
                              ),

                              const SizedBox(
                                height: 12,
                              ),

                              Text(
                                description,
                                style:
                                    const TextStyle(
                                  fontSize: 14,
                                  color: AppColors
                                      .textSecondary,
                                ),
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              if (status ==
                                  'ACCEPTED')
                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 46,
                                  child:
                                      ElevatedButton
                                          .icon(
                                    onPressed:
                                        requestId ==
                                                null
                                            ? null
                                            : () {
                                                completeBooking(
                                                  requestId,
                                                );
                                              },
                                    icon: const Icon(
                                      Icons
                                          .check_circle_rounded,
                                    ),
                                    label: const Text(
                                      'Mark as Completed',
                                    ),
                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          AppColors
                                              .success,
                                      foregroundColor:
                                          Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _iconRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
//==================== Customer Bookings Screen ====================

class CustomerBookingsScreen extends StatefulWidget {
  const CustomerBookingsScreen({super.key});

  @override
  State<CustomerBookingsScreen> createState() =>
      _CustomerBookingsScreenState();
}

class _CustomerBookingsScreenState
    extends State<CustomerBookingsScreen> {

  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final email = Session.email;

    if (email == null || email.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final result = await ApiService.getCustomerRequests(
      email: email,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      bookings = result;
      isLoading = false;
    });
  }

  String formatDate(String date) {
    final parts = date.split('-');

    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }

    return date;
  }

  String formatTime(String time) {
    try {
      final parts = time.split(':');

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookings.isEmpty
              ? const Center(
                  child: Text(
                    'No bookings available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadBookings,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = bookings[index];

                      final provider =
                          booking['provider'];

                      final service =
                          booking['service'];

                      final providerName =
                          provider?['name']?.toString() ??
                              'Unknown Provider';

                      final serviceName =
                          service?['name']?.toString() ??
                              service?['category']?.toString() ??
                              'Unknown Service';

                      final date =
                          booking['requestedDate']?.toString() ??
                              '';

                      final time =
                          booking['requestedTime']?.toString() ??
                              '';

                      final address =
                          booking['address']?.toString() ??
                              '';

                      final status =
                          booking['status']?.toString() ??
                              'PENDING';

                      final requestId =
                          int.tryParse(booking['id'].toString());

                      final displayStatus =
                          status[0].toUpperCase() +
                              status.substring(1).toLowerCase();

                      return Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        AppColors.primary
                                            .withOpacity(0.1),
                                    child: const Icon(
                                      Icons
                                          .person_rounded,
                                      color:
                                          AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 12),
                                  Expanded(
                                    child: Text(
                                      providerName,
                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight.w700,
                                        color: AppColors
                                            .textPrimary,
                                      ),
                                    ),
                                  ),
                                  StatusBadge(
                                    status:
                                        displayStatus,
                                  ),
                                ],
                              ),

                              const Divider(
                                height: 28,
                              ),

                              Text(
                                serviceName,
                                style:
                                    const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      AppColors.primary,
                                ),
                              ),

                              const SizedBox(
                                  height: 12),

                              _iconRow(
                                Icons
                                    .calendar_today_rounded,
                                formatDate(date),
                              ),

                              const SizedBox(
                                  height: 8),

                              _iconRow(
                                Icons
                                    .access_time_rounded,
                                formatTime(time),
                              ),

                              const SizedBox(
                                  height: 8),

                              _iconRow(
                                Icons
                                    .location_on_rounded,
                                address,
                              ),

                              const SizedBox(
                                  height: 18),

                              if (status == 'ACCEPTED')
                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 46,
                                  child:
                                      OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger
                                          .of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Contact feature will be added later.',
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons
                                          .phone_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Contact Provider',
                                    ),
                                  ),
                                ),

                              if (status == 'COMPLETED')
                                SizedBox(
                                  width:
                                      double.infinity,
                                  height: 46,
                                  child:
                                      OutlinedButton.icon(
                                    style:
                                        OutlinedButton
                                            .styleFrom(
                                      foregroundColor:
                                          AppColors
                                              .warning,
                                      side:
                                          const BorderSide(
                                        color: AppColors
                                            .warning,
                                      ),
                                    ),
                                    onPressed: requestId == null
                                      ? null
                                      : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RateProviderScreen(
                                                serviceRequestId: requestId,
                                                providerName: providerName,
                                              ),
                                            ),
                                          ).then((_) {
                                            loadBookings();
                                          });
                                        },
                                    
                                    icon: const Icon(
                                      Icons
                                          .star_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'Rate Provider',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _iconRow(
    IconData icon,
    String text,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

//==================== Providers Screen ====================
class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  List<dynamic> providers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProviders();
  }

  Future<void> loadProviders() async {
    final result = await ApiService.getProviders();

    if (!mounted) {
      return;
    }

    setState(() {
      providers = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Providers'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : providers.isEmpty
              ? const Center(
                  child: Text(
                    'No service providers found.',
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadProviders,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: providers.length,
                    itemBuilder: (context, index) {
                      final provider = providers[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              provider['name']
                                      ?.toString()
                                      .substring(0, 1)
                                      .toUpperCase() ??
                                  'P',
                            ),
                          ),
                          title: Text(
                            provider['name']?.toString() ??
                                'Unknown Provider',
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                provider['phone']?.toString() ??
                                    'No phone number',
                              ),
                              Text(
                                provider['email']?.toString() ??
                                    'No email',
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
//==================== Customer Profile Screen ====================

class CustomerProfileScreen
    extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor:
                  AppColors.primary.withOpacity(0.1),
              child: const Icon(
                Icons.person_rounded,
                size: 58,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Customer Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'customer@email.com',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            const InfoTile(
              icon: Icons.person_rounded,
              title: 'Full Name',
              subtitle: 'Customer Name',
            ),
            const InfoTile(
              icon: Icons.email_rounded,
              title: 'Email',
              subtitle: 'customer@email.com',
              iconColor: AppColors.secondary,
            ),
            const InfoTile(
              icon: Icons.phone_rounded,
              title: 'Phone Number',
              subtitle: '071 234 5678',
              iconColor: AppColors.success,
            ),
            const SizedBox(height: 14),

            // Become a Service Provider
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const BecomeProviderScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.handyman_rounded,
                ),
                label: const Text(
                  'Become a Service Provider',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Edit Profile
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Edit profile feature will be added later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(
                    color: AppColors.danger,
                  ),
                ),
                onPressed: () {
                  // Return to the first screen.
                  // This keeps logout behavior separate
                  // from normal Back navigation.
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  //----------------RateProviderScreen----------------//
class RateProviderScreen extends StatefulWidget {
    final int serviceRequestId;
    final String providerName;

    const RateProviderScreen({
      super.key,
      required this.serviceRequestId,
      required this.providerName,
    });

    @override
    State<RateProviderScreen> createState() =>
        _RateProviderScreenState();
  }

  class _RateProviderScreenState
      extends State<RateProviderScreen> {
    int selectedRating = 0;

    final TextEditingController commentController =
        TextEditingController();

    bool isSubmitting = false;

    @override
    void dispose() {
      commentController.dispose();
      super.dispose();
    }

    Future<void> submitReview() async {
      final email = Session.email;

      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'User session not found. Please login again.',
            ),
          ),
        );
        return;
      }

      if (selectedRating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select a rating.',
            ),
          ),
        );
        return;
      }

      if (commentController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please enter a comment.',
            ),
          ),
        );
        return;
      }

      setState(() {
        isSubmitting = true;
      });

      final success = await ApiService.addReview(
        customerEmail: email,
        serviceRequestId:
            widget.serviceRequestId,
        rating: selectedRating,
        comment: commentController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Review submitted successfully.',
            ),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to submit review.',
            ),
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rate Provider'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 42,
                backgroundColor: Color(0x1A1F3A5F),
                child: Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.providerName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'How was your experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) {
                    final starNumber = index + 1;

                    return IconButton(
                      onPressed: () {
                        setState(() {
                          selectedRating =
                              starNumber;
                        });
                      },
                      icon: Icon(
                        starNumber <=
                                selectedRating
                            ? Icons.star_rounded
                            : Icons
                                .star_border_rounded,
                        size: 45,
                        color: AppColors.warning,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              Text(
                selectedRating == 0
                    ? 'Select a rating'
                    : '$selectedRating / 5',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Review',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: commentController,
                maxLines: 5,
                textInputAction:
                    TextInputAction.newline,
                decoration: InputDecoration(
                  hintText:
                      'Write your experience...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                      isSubmitting
                          ? null
                          : submitReview,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                        ),
                  label: Text(
                    isSubmitting
                        ? 'Submitting...'
                        : 'Submit Review',
                  ),
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor:
                        Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
