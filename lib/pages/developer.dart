import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_visuals.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSecurityBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 920;

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _DeveloperTopBar(),
                        const SizedBox(height: 28),

                        const _DeveloperHero(),

                        const SizedBox(height: 28),

                        const _SectionHeader(
                          icon: Icons.groups_2,
                          title: 'Tim Pengembang',
                          subtitle:
                              'Mahasiswa yang berkolaborasi membangun sistem keamanan password modern.',
                        ),

                        const SizedBox(height: 18),

                        const _MemberGrid(),

                        const SizedBox(height: 28),

                        const _SectionHeader(
                          icon: Icons.security,
                          title: 'Fitur Sistem',
                          subtitle:
                              'Bagian utama yang mendukung keamanan password pengguna.',
                        ),

                        const SizedBox(height: 18),

                        const _FeatureGrid(),

                        const SizedBox(height: 24),

                        const _QuotePanel(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DeveloperTopBar extends StatelessWidget {
  const _DeveloperTopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: 'Kembali',
          child: IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(.10),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(text: 'Developer '),
                    TextSpan(
                      text: 'Space',
                      style: TextStyle(color: AppPalette.orange),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'PW Hash Security Dashboard',
                style: TextStyle(color: Colors.white.withOpacity(.72)),
              ),
            ],
          ),
        ),

        const BrandBadge(icon: Icons.code, label: 'Developer'),
      ],
    );
  }
}

class _DeveloperHero extends StatelessWidget {
  const _DeveloperHero();

  @override
  Widget build(BuildContext context) {
    return _GlassDarkPanel(
      padding: const EdgeInsets.all(32),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: 10,
            child: Icon(
              Icons.security,
              size: 120,
              color: Colors.white.withOpacity(.04),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppPalette.yellow, AppPalette.orange],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.lock, color: AppPalette.navy),
                  ),

                  const SizedBox(width: 14),

                  const Text(
                    'PW\nHASH',
                    style: TextStyle(
                      color: Colors.white,
                      height: .92,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const Text(
                'Tim Pengembang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),

              const Text(
                'PW Hash Lab',
                style: TextStyle(
                  color: AppPalette.orange,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: AppPalette.orange,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'PW Hash dikembangkan sebagai simulasi keamanan password modern menggunakan metode hashing SHA-256 untuk membantu pengguna memahami pentingnya perlindungan data akun.',
                style: TextStyle(
                  color: Colors.white.withOpacity(.82),
                  fontSize: 16,
                  height: 1.7,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Kami membangun dashboard ini dengan fokus pada keamanan, tampilan modern, serta pengalaman pengguna yang responsif dan mudah digunakan.',
                style: TextStyle(
                  color: Colors.white.withOpacity(.72),
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppPalette.orange, size: 28),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: TextStyle(color: Colors.white.withOpacity(.70)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemberGrid extends StatelessWidget {
  const _MemberGrid();

  static const members = [
    _MemberData(
      'Dewi Berliana',
      '25051204284',
      'https://github.com/Berliana003',
      'https://www.instagram.com/berliand_aa',
    ),

    _MemberData(
      'Dinda Dwi Febiani',
      '25051204282',
      'https://github.com/Dinda-2802',
      'https://www.instagram.com/dindafbiani?igsh=YXltejBoMDl1Zmtu',
    ),

    _MemberData(
      'Chantika Putri Meunasah',
      '25051204264',
      'https://github.com/Chantikaputrii',
      'https://www.instagram.com/channntk?igsh=N2RmNmtvaXBtYWNm',
    ),

    _MemberData(
      "Yusa' Eka Setiawan",
      '25051204366',
      'https://github.com/Yusa137D',
      'https://www.instagram.com/ysekstwn?igsh=MWQ0dGxtcGVzYzh3YQ%3D%3D&utm_source=qr',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1020
            ? 4
            : constraints.maxWidth >= 700
            ? 2
            : 1;

        const spacing = 16.0;

        final width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final member in members)
              SizedBox(
                width: width,
                child: _MemberCard(member: member),
              ),
          ],
        );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  final _MemberData member;

  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return _GlassDarkPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppPalette.yellow.withOpacity(.9),
                      AppPalette.orange.withOpacity(.9),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppPalette.navy,
                  size: 32,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'NIM • ${member.nim}',
                      style: const TextStyle(
                        color: AppPalette.orange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  icon: Icons.code,
                  label: 'GitHub',
                  borderColor: AppPalette.yellow,
                  onTap: () => openLink(member.github),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _SocialButton(
                  icon: Icons.camera_alt_outlined,
                  label: 'Instagram',
                  borderColor: AppPalette.orange,
                  onTap: () => openLink(member.instagram),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const features = [
    _FeatureData(
      Icons.dashboard_customize_outlined,
      'Dashboard Modern',
      'Tampilan responsif dan modern untuk memudahkan monitoring keamanan password pengguna.',
      AppPalette.yellow,
    ),

    _FeatureData(
      Icons.lock_outline,
      'SHA-256 Security',
      'Sistem menggunakan metode hashing SHA-256 untuk meningkatkan keamanan data akun.',
      AppPalette.orange,
    ),

    _FeatureData(
      Icons.devices,
      'Responsive Layout',
      'Desain fleksibel yang nyaman digunakan di desktop maupun perangkat mobile.',
      Colors.lightBlueAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 620
            ? 2
            : 1;

        const spacing = 16.0;

        final width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final feature in features)
              SizedBox(
                width: width,
                child: _FeatureCard(feature: feature),
              ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return _GlassDarkPanel(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: feature.color.withOpacity(.12),
              shape: BoxShape.circle,
            ),
            child: Icon(feature.icon, color: feature.color, size: 34),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  feature.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.70),
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotePanel extends StatelessWidget {
  const _QuotePanel();

  @override
  Widget build(BuildContext context) {
    return _GlassDarkPanel(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      child: Row(
        children: [
          const Icon(Icons.format_quote, color: AppPalette.orange, size: 42),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              'Keamanan password bukan hanya tentang teknologi, tetapi juga tentang menjaga privasi dan kepercayaan pengguna di era digital.',
              style: TextStyle(
                color: Colors.white.withOpacity(.82),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassDarkPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassDarkPanel({
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff1e293b), Color(0xff334155), Color(0xff0f172a)],
        ),

        borderRadius: BorderRadius.circular(28),

        border: Border.all(color: Colors.white.withOpacity(.08)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),

          BoxShadow(
            color: AppPalette.orange.withOpacity(.10),
            blurRadius: 30,
            spreadRadius: -8,
          ),
        ],
      ),

      child: child,
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color borderColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: borderColor.withOpacity(.7)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: borderColor),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

Future<void> openLink(String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _MemberData {
  final String name;
  final String nim;
  final String github;
  final String instagram;

  const _MemberData(this.name, this.nim, this.github, this.instagram);
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureData(this.icon, this.title, this.description, this.color);
}
