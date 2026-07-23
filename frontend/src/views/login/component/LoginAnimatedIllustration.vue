<template>
  <div class="login-animated-illustration" aria-hidden="true">
    <svg class="login-anim-svg" viewBox="0 0 420 300" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="login-anim-grad" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stop-color="var(--el-color-primary-light-5)" />
          <stop offset="100%" stop-color="var(--el-color-primary)" />
        </linearGradient>
      </defs>

      <path
        class="login-anim-trail"
        d="M 118 168 C 175 95, 245 95, 298 138"
        fill="none"
        stroke="url(#login-anim-grad)"
        stroke-width="2"
        stroke-linecap="round"
        stroke-dasharray="8 12"
      />

      <g class="login-anim-laptop">
        <rect x="52" y="118" width="120" height="78" rx="10" fill="var(--el-color-primary-light-7)" />
        <rect x="60" y="126" width="104" height="56" rx="6" fill="var(--el-bg-color)" />
        <rect x="98" y="144" width="28" height="22" rx="4" fill="var(--el-color-primary-light-5)" />
        <path d="M 40 204 L 184 204 L 188 212 L 36 212 Z" fill="var(--el-color-primary-light-7)" />
      </g>

      <g class="login-anim-sheet login-anim-sheet--a">
        <rect x="0" y="0" width="36" height="46" rx="5" fill="var(--el-bg-color)" stroke="var(--el-color-primary-light-5)" stroke-width="2" />
        <line x1="8" y1="14" x2="28" y2="14" stroke="var(--el-color-primary-light-5)" stroke-width="2" stroke-linecap="round" />
        <line x1="8" y1="24" x2="24" y2="24" stroke="var(--el-color-primary-light-7)" stroke-width="2" stroke-linecap="round" />
      </g>
      <g class="login-anim-sheet login-anim-sheet--b">
        <rect x="0" y="0" width="32" height="40" rx="5" fill="var(--el-bg-color)" stroke="var(--el-color-primary-light-5)" stroke-width="2" />
        <line x1="7" y1="12" x2="25" y2="12" stroke="var(--el-color-primary-light-5)" stroke-width="2" stroke-linecap="round" />
      </g>

      <g class="login-anim-target">
        <rect x="268" y="124" width="112" height="86" rx="12" fill="var(--el-color-primary)" />
        <path d="M 268 148 L 322 148 L 338 136 L 380 136 L 380 148 L 268 148 Z" fill="var(--el-color-primary-dark-2)" opacity="0.35" />
        <path
          class="login-anim-check"
          d="M 302 176 L 318 192 L 352 158"
          fill="none"
          stroke="var(--el-bg-color)"
          stroke-width="6"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </g>

      <g class="login-anim-pedestal">
        <rect x="196" y="218" width="28" height="44" rx="6" fill="var(--el-color-primary-light-7)" />
      </g>
    </svg>
  </div>
</template>

<script setup lang="ts" name="LoginAnimatedIllustration">
</script>

<style lang="scss" scoped>
.login-animated-illustration {
  width: 100%;
  height: 100%;
}

.login-anim-svg {
  display: block;
  width: 100%;
  height: 100%;
}

.login-anim-trail {
  opacity: 0.55;
  animation: login-trail-dash 2.4s linear infinite;
}

.login-anim-laptop {
  transform-origin: 112px 170px;
  animation: login-float 3.2s ease-in-out infinite;
}

.login-anim-target {
  transform-origin: 324px 168px;
  animation: login-float 3.2s ease-in-out infinite;
  animation-delay: -1.1s;
}

.login-anim-check {
  animation: login-check-pop 2.4s ease-in-out infinite;
}

.login-anim-pedestal {
  transform-box: fill-box;
  transform-origin: 210px 240px;
  animation: login-pedestal 3.2s ease-in-out infinite;
}

.login-anim-sheet {
  transform-box: fill-box;
  transform-origin: center;
}

.login-anim-sheet--a {
  transform: translate(86px, 132px) rotate(-8deg);
  animation: login-sheet-a 3.6s ease-in-out infinite;
}

.login-anim-sheet--b {
  transform: translate(108px, 118px) rotate(6deg);
  animation: login-sheet-b 3.6s ease-in-out infinite;
  animation-delay: -0.6s;
}

@keyframes login-trail-dash {
  to {
    stroke-dashoffset: -80;
  }
}

@keyframes login-float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-7px);
  }
}

@keyframes login-check-pop {
  0%,
  100% {
    opacity: 1;
  }
  45% {
    opacity: 0.55;
  }
  55% {
    opacity: 1;
  }
}

@keyframes login-pedestal {
  0%,
  100% {
    transform: scaleY(1);
  }
  50% {
    transform: scaleY(1.04);
  }
}

@keyframes login-sheet-a {
  0%,
  100% {
    transform: translate(86px, 132px) rotate(-8deg);
  }
  50% {
    transform: translate(200px, 108px) rotate(6deg) translateY(-4px);
  }
}

@keyframes login-sheet-b {
  0%,
  100% {
    transform: translate(108px, 118px) rotate(6deg);
  }
  50% {
    transform: translate(218px, 100px) rotate(-4deg) translateY(-6px);
  }
}

@media (prefers-reduced-motion: reduce) {
  .login-anim-trail,
  .login-anim-laptop,
  .login-anim-target,
  .login-anim-check,
  .login-anim-pedestal,
  .login-anim-sheet--a,
  .login-anim-sheet--b {
    animation: none !important;
  }
}
</style>
