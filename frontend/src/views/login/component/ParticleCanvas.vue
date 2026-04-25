<template>
	<canvas ref="canvasRef" class="particle-canvas" />
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue';

const canvasRef = ref<HTMLCanvasElement | null>(null);

interface Particle {
	x: number;
	y: number;
	vx: number;
	vy: number;
	radius: number;
	opacity: number;
}

let animationId = 0;
let particles: Particle[] = [];
let ctx: CanvasRenderingContext2D | null = null;
let W = 0;
let H = 0;

const PARTICLE_COUNT = 100;
const MAX_DIST = 150;       // 连线最大距离
const PARTICLE_COLOR = '80, 100, 160';  // 深蓝灰色
const LINE_COLOR = '80, 100, 160';

function resize() {
	const canvas = canvasRef.value;
	if (!canvas) return;
	W = canvas.width = canvas.offsetWidth;
	H = canvas.height = canvas.offsetHeight;
}

function createParticles() {
	particles = [];
	for (let i = 0; i < PARTICLE_COUNT; i++) {
		particles.push({
			x: Math.random() * W,
			y: Math.random() * H,
			vx: (Math.random() - 0.5) * 0.6,
			vy: (Math.random() - 0.5) * 0.6,
			radius: Math.random() * 2 + 1.5,
			opacity: Math.random() * 0.3 + 0.25,
		});
	}
}

function draw() {
	if (!ctx) return;
	ctx.clearRect(0, 0, W, H);

	// Draw lines between nearby particles
	for (let i = 0; i < particles.length; i++) {
		for (let j = i + 1; j < particles.length; j++) {
			const dx = particles[i].x - particles[j].x;
			const dy = particles[i].y - particles[j].y;
			const dist = Math.sqrt(dx * dx + dy * dy);
			if (dist < MAX_DIST) {
				const alpha = (1 - dist / MAX_DIST) * 0.4;
				ctx.beginPath();
				ctx.strokeStyle = `rgba(${LINE_COLOR}, ${alpha})`;
				ctx.lineWidth = 0.8;
				ctx.moveTo(particles[i].x, particles[i].y);
				ctx.lineTo(particles[j].x, particles[j].y);
				ctx.stroke();
			}
		}
	}

	// Draw particles
	for (const p of particles) {
		ctx.beginPath();
		ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
		ctx.fillStyle = `rgba(${PARTICLE_COLOR}, ${p.opacity})`;
		ctx.fill();
	}
}

function update() {
	for (const p of particles) {
		p.x += p.vx;
		p.y += p.vy;
		// Bounce off edges
		if (p.x < 0 || p.x > W) p.vx *= -1;
		if (p.y < 0 || p.y > H) p.vy *= -1;
		// Clamp
		p.x = Math.max(0, Math.min(W, p.x));
		p.y = Math.max(0, Math.min(H, p.y));
	}
}

function loop() {
	update();
	draw();
	animationId = requestAnimationFrame(loop);
}

// Mouse interaction — attract nearby particles toward cursor
function onMouseMove(e: MouseEvent) {
	const canvas = canvasRef.value;
	if (!canvas) return;
	const rect = canvas.getBoundingClientRect();
	const mx = e.clientX - rect.left;
	const my = e.clientY - rect.top;
	for (const p of particles) {
		const dx = mx - p.x;
		const dy = my - p.y;
		const dist = Math.sqrt(dx * dx + dy * dy);
		if (dist < 120) {
			p.vx += dx / dist * 0.08;
			p.vy += dy / dist * 0.08;
			// Cap speed
			const speed = Math.sqrt(p.vx * p.vx + p.vy * p.vy);
			if (speed > 2) {
				p.vx = (p.vx / speed) * 2;
				p.vy = (p.vy / speed) * 2;
			}
		}
	}
}

const resizeObserver = new ResizeObserver(() => {
	resize();
	createParticles();
});

onMounted(() => {
	const canvas = canvasRef.value;
	if (!canvas) return;
	ctx = canvas.getContext('2d');
	resize();
	createParticles();
	loop();
	resizeObserver.observe(canvas.parentElement || canvas);
	canvas.addEventListener('mousemove', onMouseMove);
});

onUnmounted(() => {
	cancelAnimationFrame(animationId);
	resizeObserver.disconnect();
	canvasRef.value?.removeEventListener('mousemove', onMouseMove);
});
</script>

<style scoped>
.particle-canvas {
	position: absolute;
	inset: 0;
	width: 100%;
	height: 100%;
	pointer-events: auto;
	z-index: 0;
}
</style>
