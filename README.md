# 🧟‍♂️ Zombie Arena - 3D Survival Platformer

An epic 3D zombie survival game with intense platformer mechanics, built in Godot Engine 4.4. Fight through endless waves of terrifying zombies in a massive arena while using strategic vertical movement to survive!

![Zombie Arena](https://img.shields.io/badge/Godot-4.4-blue?style=for-the-badge&logo=godot-engine)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

## 🎮 Game Features

### 🏃‍♂️ **Epic Platformer Mechanics**
- **High Jump System**: 167% enhanced jump height for epic vertical movement
- **15 Strategic Platforms**: Multi-level arena with platforms ranging from 2.5 to 16 units high
- **Parkour Navigation**: Fluid movement through vertical battlefield
- **Strategic Positioning**: Use height advantage for tactical combat

### 🧟‍♂️ **Intense Zombie Combat**
- **Endless Wave System**: Face increasingly difficult zombie hordes
- **Terrifying Visuals**: Zombies with glowing red eyes and enhanced models
- **Smart AI**: Zombies hunt the player with realistic pathfinding
- **Progressive Difficulty**: Each wave brings more zombies and challenges

### 🔫 **Professional Weapon System**
- **Realistic Shooting**: Precise bullet physics with proper trajectories
- **Ammo Management**: 30-round magazine with tactical reload system
- **Weapon Model**: Detailed 3D gun with barrel and realistic proportions
- **Audio Feedback**: Professional gunshot and reload sound effects

### 🎵 **Cinema-Quality Audio**
- **Procedural Sound Generation**: All sounds created with advanced synthesis
- **Realistic Gunshots**: Multi-layered explosion, crack, echo, and noise components
- **Terrifying Zombie Audio**: 5-layer vocal harmonics with breathing effects
- **Immersive Footsteps**: Automatic footstep detection with realistic impact sounds
- **Atmospheric Soundscape**: Dynamic background music and ambient horror sounds

### 🌟 **Professional Visual Design**
- **Massive 120x120 Arena**: 4x larger battlefield than standard games
- **Dynamic Lighting**: Professional spot lights with realistic shadows
- **Environmental Design**: Strategic obstacles and multi-level architecture
- **Modern Materials**: Metallic surfaces, realistic textures, and proper shading

## 🎯 Gameplay

### Controls
- **WASD**: Move around the arena
- **Mouse**: Look around and aim
- **Left Click**: Shoot (hold for continuous fire)
- **R**: Reload weapon
- **Space**: Jump (enhanced height for platform navigation)

### Strategy Tips
- 🏗️ **Use High Platforms**: Jump to elevated positions for better shooting angles
- 🏃‍♂️ **Stay Mobile**: Don't get cornered by zombie hordes
- 🎯 **Conserve Ammo**: Reload strategically when safe on platforms
- 📍 **Control Center**: The highest platform (16 units) offers the best vantage point
- 🔄 **Platform Hopping**: Move between platforms to avoid being overwhelmed

## 🚀 Technical Specifications

### Built With
- **Godot Engine 4.4.1**: Latest stable version with advanced 3D capabilities
- **GDScript**: Efficient game logic and systems programming
- **Advanced Physics**: Realistic character movement and bullet trajectories
- **Procedural Audio**: Real-time sound synthesis for immersive experience

### Performance Features
- **Optimized Rendering**: Efficient handling of large arena and multiple entities
- **Smart Spawning**: Intelligent zombie spawn system around arena perimeter
- **Memory Management**: Proper cleanup of bullets and zombie instances
- **Scalable Difficulty**: Progressive wave system that adapts to player skill

## 📁 Project Structure

```
ZombieArena/
├── Main.gd              # Core game logic and wave management
├── Main.tscn            # Main game scene with arena and lighting
├── Player.gd            # Player movement, shooting, and health system
├── Zombie.gd            # Zombie AI, pathfinding, and combat
├── Zombie.tscn          # Zombie 3D model and components
├── Bullet.gd            # Bullet physics and collision detection
├── Bullet.tscn          # Bullet 3D model and effects
├── UI.gd                # User interface and HUD management
├── UI.tscn              # Game interface layout
├── MainMenu.gd          # Main menu system
├── MainMenu.tscn        # Main menu scene
└── project.godot        # Godot project configuration
```

## 🛠️ Installation & Setup

### Prerequisites
- Godot Engine 4.4 or later
- Git (for cloning the repository)

### Quick Start
1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/zombie-arena.git
   cd zombie-arena
   ```

2. **Open in Godot**
   - Launch Godot Engine
   - Click "Import"
   - Navigate to the project folder
   - Select `project.godot`
   - Click "Import & Edit"

3. **Run the Game**
   - Press F5 or click the Play button
   - Select `MainMenu.tscn` when prompted
   - Enjoy the zombie survival experience!

## 🎮 Game Systems

### Wave System
- **Base Zombies**: 8 zombies per wave initially
- **Scaling**: Each wave adds 8 more zombies (Wave 1: 8, Wave 2: 16, Wave 3: 24...)
- **Max Waves**: 100 waves of increasing difficulty
- **Break Time**: 3-second pause between waves for strategic planning

### Health & Damage
- **Player Health**: 100 HP with visual health bar
- **Zombie Damage**: Balanced damage system for fair challenge
- **Health Display**: Real-time health monitoring in UI

### Audio System
- **Background Music**: Atmospheric horror soundtrack with regenerative loops
- **Sound Effects**: Procedurally generated realistic audio
- **Spatial Audio**: Proper 3D sound positioning and effects

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs and issues
- Suggest new features
- Submit pull requests
- Improve documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🏆 Achievements

This game features:
- ✅ **Professional 3D Graphics** with advanced lighting and materials
- ✅ **Cinema-Quality Audio** with procedural sound synthesis
- ✅ **Strategic Platformer Gameplay** with 15 functional platforms
- ✅ **Intelligent AI System** with realistic zombie behavior
- ✅ **Scalable Difficulty** supporting 100+ waves
- ✅ **Immersive Experience** with atmospheric design and effects

## 🎯 Future Enhancements

Potential future additions:
- 🏪 **Weapon Upgrades**: Multiple weapon types and upgrade systems
- 💎 **Power-ups**: Special abilities and temporary enhancements
- 🏅 **Leaderboards**: High score tracking and achievements
- 🌍 **Multiple Arenas**: Different environments and challenges
- 👥 **Multiplayer**: Cooperative survival mode

---

**Built with ❤️ using Godot Engine 4.4**

*Experience the ultimate zombie survival platformer with cinema-quality audio and professional 3D graphics!*
