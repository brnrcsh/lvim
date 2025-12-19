return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        apex_ls = {
          apex_jar_path = vim.fn.stdpath("data") .. "/mason/share/apex-language-server/apex-jorje-lsp.jar",
          cmd = function(dispatchers, config)
            ---@diagnostic disable: undefined-field
            local local_cmd = {
              vim.env.JAVA_HOME and (vim.env.JAVA_HOME .. "/bin/java") or "java",
              "-cp",
              config.apex_jar_path,
              "-Ddebug.internal.errors=true",
              "-Ddebug.semantic.errors=" .. tostring(config.apex_enable_semantic_errors or false),
              "-Ddebug.completion.statistics=" .. tostring(config.apex_enable_completion_statistics or false),
              "-Dlwc.typegeneration.disabled=true",
            }
            if config.apex_jvm_max_heap then
              table.insert(local_cmd, "-Xmx" .. config.apex_jvm_max_heap)
            end
            ---@diagnostic enable: undefined-field
            table.insert(local_cmd, "apex.jorje.lsp.ApexLanguageServerLauncher")

            return vim.lsp.rpc.start(local_cmd, dispatchers)
          end,
          filetypes = { "apex", "apexcode" },
          root_markers = {
            "sfdx-project.json",
          },
        },
      },
    },
  },
}
