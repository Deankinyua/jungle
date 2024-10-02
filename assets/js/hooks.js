let Hooks = {};

Hooks.ClickHook = {
  mounted() {
    console.log("ClickHook is mounted!");
    this.el.addEventListener("click", () => {
      alert("Button was clicked!");
    });
  },
};

export default Hooks;
