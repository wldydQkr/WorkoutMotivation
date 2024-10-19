//
//  ParticleEffect.swift
//  WorkoutMotivation
//
//  Created by 박지용 on 10/19/24.
//

import SwiftUI

// 폭죽 애니메이션을 구현하는 ParticleEffect 뷰
struct ParticleEffect: View {
    @State private var particles: [Particle] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                        .animation(.easeOut(duration: 0.5), value: particle.position)
                }
            }
            .onAppear {
                generateParticles(in: geometry.size)
            }
        }
    }

    private func generateParticles(in size: CGSize) {
        let colors: [Color] = [.red, .yellow, .blue, .green, .orange]
        for _ in 0..<10 { // 파티클 수
            let particle = Particle(
                id: UUID(),
                position: CGPoint(x: size.width / 2, y: size.height / 2),
                size: CGFloat.random(in: 4...8), // 미니멀한 크기
                color: colors.randomElement() ?? .white,
                opacity: Double.random(in: 0.7...1.0)
            )
            particles.append(particle)

            // 파티클을 균일하게 퍼트리기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                particles = particles.map { particle in
                    var updatedParticle = particle
                    updatedParticle.position.x += CGFloat.random(in: -20...20) // 적은 범위로 균일하게 퍼짐
                    updatedParticle.position.y += CGFloat.random(in: -20...20)
                    return updatedParticle
                }
            }
        }
    }
}
