function revealSection(sectionId) {
  const sections = document.querySelectorAll('.block-hidable');
  sections.forEach(section => {
      section.classList.remove('active');
  });

  const activeSection = document.getElementById(sectionId);
  if (activeSection) {
      activeSection.classList.add('active');
  }
}