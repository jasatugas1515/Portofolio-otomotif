/* Core UI initialization */
document.addEventListener("DOMContentLoaded", () => {
  const root = document.documentElement;
  const body = document.body;
  const loader = document.querySelector(".site-loader");
  const header = document.querySelector(".site-header");
  const navToggle = document.querySelector(".nav-toggle");
  const mobileMenu = document.querySelector(".mobile-menu");
  const progressBar = document.querySelector(".scroll-progress");
  const typingTarget = document.querySelector(".typing-text");
  const revealItems = document.querySelectorAll(".reveal");
  const counterItems = document.querySelectorAll("[data-counter]");
  const skillBars = document.querySelectorAll("[data-progress]");
  const tiltCards = document.querySelectorAll(".tilt-card");
  const magneticItems = document.querySelectorAll(".magnetic");
  const hoverTargets = document.querySelectorAll("a, button, .tilt-card");
  const outerCursor = document.querySelector(".cursor--outer");
  const themeButtons = document.querySelectorAll(".theme-toggle");
  const navMore = document.querySelector(".nav-more");
  const navMoreToggle = document.querySelector(".nav-more__toggle");

  /* Loader */
  window.addEventListener("load", () => {
    window.setTimeout(() => loader?.classList.add("is-hidden"), 650);
  });

  /* Icon replacement */
  if (window.lucide) {
    window.lucide.createIcons();
  }

  /* Theme persistence */
  const savedTheme = window.localStorage.getItem("portfolio-theme");
  if (savedTheme) {
    root.setAttribute("data-theme", savedTheme);
  }

  themeButtons.forEach((button) => {
    button.addEventListener("click", () => {
      const nextTheme = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
      root.setAttribute("data-theme", nextTheme);
      window.localStorage.setItem("portfolio-theme", nextTheme);
    });
  });

  /* Mobile navigation */
  navToggle?.addEventListener("click", () => {
    const isOpen = mobileMenu.classList.toggle("is-open");
    navToggle.classList.toggle("is-active", isOpen);
    navToggle.setAttribute("aria-expanded", String(isOpen));
  });

  document.querySelectorAll(".mobile-menu a").forEach((link) => {
    link.addEventListener("click", () => {
      mobileMenu.classList.remove("is-open");
      navToggle?.classList.remove("is-active");
      navToggle?.setAttribute("aria-expanded", "false");
    });
  });

  /* Compact desktop dropdown */
  navMoreToggle?.addEventListener("click", () => {
    const isOpen = navMore?.classList.toggle("is-open");
    navMoreToggle.setAttribute("aria-expanded", String(Boolean(isOpen)));
  });

  document.addEventListener("click", (event) => {
    if (!navMore || !navMoreToggle) {
      return;
    }

    if (!navMore.contains(event.target)) {
      navMore.classList.remove("is-open");
      navMoreToggle.setAttribute("aria-expanded", "false");
    }
  });

  document.querySelectorAll(".nav-more__menu a").forEach((link) => {
    link.addEventListener("click", () => {
      navMore?.classList.remove("is-open");
      navMoreToggle?.setAttribute("aria-expanded", "false");
    });
  });

  /* Sticky header and progress bar */
  const updateScrollUi = () => {
    const scrollTop = window.scrollY;
    const pageHeight = document.documentElement.scrollHeight - window.innerHeight;
    const progress = pageHeight > 0 ? (scrollTop / pageHeight) * 100 : 0;

    header?.classList.toggle("is-scrolled", scrollTop > 24);
    if (progressBar) {
      progressBar.style.width = `${progress}%`;
    }
  };

  window.addEventListener("scroll", updateScrollUi, { passive: true });
  updateScrollUi();

  /* Typing effect */
  if (typingTarget) {
    const words = JSON.parse(typingTarget.dataset.typing || "[]");
    let wordIndex = 0;
    let charIndex = 0;
    let isDeleting = false;

    const typeLoop = () => {
      const currentWord = words[wordIndex] || "";
      const nextText = isDeleting
        ? currentWord.slice(0, charIndex--)
        : currentWord.slice(0, charIndex++);

      typingTarget.textContent = nextText;

      let delay = isDeleting ? 55 : 95;

      if (!isDeleting && nextText === currentWord) {
        delay = 1600;
        isDeleting = true;
      } else if (isDeleting && nextText === "") {
        isDeleting = false;
        wordIndex = (wordIndex + 1) % words.length;
        charIndex = 0;
        delay = 300;
      }

      window.setTimeout(typeLoop, delay);
    };

    typeLoop();
  }

  /* Reveal observers */
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.16 });

  revealItems.forEach((item) => revealObserver.observe(item));

  /* Counter and progress animations */
  const animatedNodes = new WeakSet();
  const statsObserver = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting || animatedNodes.has(entry.target)) {
        return;
      }

      animatedNodes.add(entry.target);

      if (entry.target.matches("[data-counter]")) {
        animateCounter(entry.target);
      }

      if (entry.target.matches("[data-progress]")) {
        entry.target.style.width = `${entry.target.dataset.progress}%`;
      }

      statsObserver.unobserve(entry.target);
    });
  }, { threshold: 0.4 });

  counterItems.forEach((item) => statsObserver.observe(item));
  skillBars.forEach((bar) => statsObserver.observe(bar));

  function animateCounter(element) {
    const target = Number(element.dataset.counter || 0);
    const duration = 1800;
    const startTime = performance.now();

    const tick = (time) => {
      const progress = Math.min((time - startTime) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      element.textContent = `${Math.floor(target * eased)}${target >= 25 ? "+" : ""}`;

      if (progress < 1) {
        window.requestAnimationFrame(tick);
      } else {
        element.textContent = `${target}+`;
      }
    };

    window.requestAnimationFrame(tick);
  }

  /* Cursor glow and custom cursor */
  const updatePointer = (event) => {
    const x = event.clientX;
    const y = event.clientY;
    root.style.setProperty("--mouse-x", `${x}px`);
    root.style.setProperty("--mouse-y", `${y}px`);
    root.style.setProperty("--cursor-x", `${x}px`);
    root.style.setProperty("--cursor-y", `${y}px`);
  };

  window.addEventListener("pointermove", updatePointer, { passive: true });

  hoverTargets.forEach((item) => {
    item.addEventListener("mouseenter", () => outerCursor?.classList.add("is-hovering"));
    item.addEventListener("mouseleave", () => outerCursor?.classList.remove("is-hovering"));
  });

  /* Magnetic interactions */
  magneticItems.forEach((item) => {
    item.addEventListener("pointermove", (event) => {
      const rect = item.getBoundingClientRect();
      const offsetX = event.clientX - rect.left - rect.width / 2;
      const offsetY = event.clientY - rect.top - rect.height / 2;
      item.style.transform = `translate(${offsetX * 0.12}px, ${offsetY * 0.12}px)`;
    });

    item.addEventListener("pointerleave", () => {
      item.style.transform = "";
    });
  });

  /* Tilt interactions */
  tiltCards.forEach((card) => {
    card.addEventListener("pointermove", (event) => {
      const rect = card.getBoundingClientRect();
      const rotateX = ((event.clientY - rect.top) / rect.height - 0.5) * -8;
      const rotateY = ((event.clientX - rect.left) / rect.width - 0.5) * 10;
      card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-4px)`;
    });

    card.addEventListener("pointerleave", () => {
      card.style.transform = "";
    });
  });

  /* Simple parallax */
  const parallaxElements = document.querySelectorAll(".blob, .floating-icon");
  window.addEventListener("scroll", () => {
    const offset = window.scrollY * 0.04;
    parallaxElements.forEach((element, index) => {
      const direction = index % 2 === 0 ? 1 : -1;
      element.style.transform = `translate3d(${direction * offset}px, ${offset}px, 0)`;
    });
  }, { passive: true });

  /* Keyboard nav support */
  body.addEventListener("keyup", (event) => {
    if (event.key === "Escape" && mobileMenu.classList.contains("is-open")) {
      mobileMenu.classList.remove("is-open");
      navToggle?.classList.remove("is-active");
      navToggle?.setAttribute("aria-expanded", "false");
    }
  });
});
