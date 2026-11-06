// "pipeline" style for scripts/slides.sh decks: the deck is a CI pipeline
// run. Each "# Section" is a stage and each slide a job (both named by
// {channel=...} on the heading, or from the title). Jobs before the current
// slide pass, the current one runs, the rest are pending; the run passes on
// the last slide. Click a job to jump to it.
(function () {
  var DARK = '#0d1117';

  function slug(text) {
    return text.toLowerCase().replace(/&/g, 'and').replace(/[’']/g, '')
      .replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 24).replace(/-$/, '');
  }
  function el(tag, cls, html) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html) e.innerHTML = html;
    return e;
  }
  function esc(t) { return t.replace(/[&<>]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;' }[c]; }); }

  function build() {
    var slides = Reveal.getSlides();
    var title = (document.querySelector('#title-slide h1') || {}).textContent || 'deck';
    var author = ((document.querySelector('#title-slide .author') || {}).textContent || 'me').trim();
    var bar = el('div', 'pl-bar');
    var run = el('div', 'pl-run');
    var stagesEl = el('div', 'pl-stages');
    bar.appendChild(run);
    bar.appendChild(stagesEl);
    document.body.appendChild(bar);

    // Group slides into stages
    var stages = [], jobs = [];
    slides.forEach(function (s) {
      var h = s.querySelector('h1, h2');
      var text = h ? h.textContent : '';
      var isTitle = s.id === 'title-slide';
      var isSection = s.classList.contains('level1');
      if (isTitle || isSection || !stages.length) {
        stages.push({ name: isTitle ? 'start' : (s.getAttribute('data-channel') || slug(text)), jobs: [] });
      }
      var name = isTitle ? 'checkout' : isSection ? 'stage' : (s.getAttribute('data-channel') || slug(text));
      var job = { slide: s, name: name, title: isTitle ? title : text, stage: stages[stages.length - 1] };
      job.stage.jobs.push(job);
      jobs.push(job);

      if (isTitle || isSection) {
        s.setAttribute('data-background-color', DARK);
        var stageNo = stages.length - 1;
        var log = isTitle
          ? '<span class="ok">$</span> pipeline run --ref main --triggered-by "' + esc(author) + '"<br>' +
            '<span class="run">●</span> fetching story… <span class="ok">done</span>'
          : '<span class="run">▶</span> stage ' + stageNo + ': <b>' + esc(stages[stageNo].name) + '</b>';
        s.insertBefore(el('div', 'pl-log', log), s.firstChild);
      } else {
        var kicker = el('div', 'pl-kicker', '<span class="pl-dot"></span>' + esc(job.stage.name) + ' / ' + esc(name));
        s.insertBefore(kicker, s.firstChild);
      }
    });

    stages.forEach(function (st, n) {
      if (n > 0) { st.link = el('div', 'pl-link'); stagesEl.appendChild(st.link); }
      st.el = el('div', 'pl-stage');
      st.el.appendChild(el('div', 'pl-stage-name', esc(st.name)));
      var row = el('div', 'pl-jobs');
      st.jobs.forEach(function (j) {
        j.el = el('div', 'pl-job');
        j.el.title = j.name + ': ' + j.title;
        j.el.addEventListener('click', function () {
          var ix = Reveal.getIndices(j.slide);
          Reveal.slide(ix.h, ix.v);
        });
        row.appendChild(j.el);
      });
      st.el.appendChild(row);
      stagesEl.appendChild(st.el);
    });

    function update() {
      var cur = Reveal.getCurrentSlide();
      var at = jobs.findIndex(function (j) { return j.slide === cur; });
      var last = at === jobs.length - 1;
      jobs.forEach(function (j, n) {
        j.el.className = 'pl-job ' + (n < at || last ? 'passed' : n === at ? 'running' : 'pending');
      });
      stages.forEach(function (st) {
        var first = jobs.indexOf(st.jobs[0]);
        var lastJob = jobs.indexOf(st.jobs[st.jobs.length - 1]);
        st.el.classList.toggle('current', at >= first && at <= lastJob);
        if (st.link) st.link.classList.toggle('done', at >= first);
      });
      run.innerHTML = '<b>' + esc(title) + '</b><br>job ' + (at + 1) + ' of ' + jobs.length +
        (last ? '<span class="pl-status passed">passed</span>' : '<span class="pl-status">running</span>');
    }
    Reveal.on('slidechanged', update);
    Reveal.sync();
    Reveal.layout();
    update();
  }

  if (Reveal.isReady()) build(); else Reveal.on('ready', build);
})();
