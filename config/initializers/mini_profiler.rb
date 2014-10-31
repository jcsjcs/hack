# Don't collect backtraces on SQL queries that take less than 5 ms to execute
# (necessary on Rubies earlier than 2.0)
#Rack::MiniProfiler.config.backtrace_threshold_ms = 5
