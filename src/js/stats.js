async function updateServerStats() {
    try {
        // Fetch static stats JSON updated by cron
        const response = await fetch('stats.json?cache=' + Date.now());
        if (!response.ok) return;

        const data = await response.json();

        document.getElementById('cpu-val').innerText = `${data.cpu_usage}%`;
        document.getElementById('ram-val').innerText = `${data.ram_used_mb}MB / ${data.ram_total_mb}MB`;
        document.getElementById('disk-val').innerText = `${data.disk_free_gb} GB`;
        document.getElementById('uptime-val').innerText = data.uptime;
    } catch (e) {
        console.warn('Could not load server stats JSON');
    }
}

// Fetch stats on load and every 10 seconds
updateServerStats();
setInterval(updateServerStats, 10000);