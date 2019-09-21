#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>

static char* ngx_http_test2query1(ngx_conf_t* cf, ngx_command_t* cmd, void* conf);
static ngx_int_t ngx_http_test2query1_handler(ngx_http_request_t* r);

static ngx_command_t ngx_http_test2query1_commands[] = {
  {
    ngx_string("test2query1"),
    NGX_HTTP_LOC_CONF|NGX_CONF_NOARGS,
    ngx_http_test2query1,
    0,
    0,
    NULL
  },
  ngx_null_command
};

static ngx_http_module_t ngx_http_test2query1_module_ctx = {
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL
};

ngx_module_t ngx_http_test2query1_module = {
  NGX_MODULE_V1,
  &ngx_http_test2query1_module_ctx,
  ngx_http_test2query1_commands,
  NGX_HTTP_MODULE,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NGX_MODULE_V1_PADDING
};

static ngx_int_t ngx_http_test2query1_handler(ngx_http_request_t* r) {
  r->headers_out.content_type.len  = sizeof("application/json") - 1;
  r->headers_out.content_type.data = (uint8_t*) "application/json";

  static ngx_buf_t* b = NULL;
  b = ngx_pcalloc(r->pool, sizeof(ngx_buf_t));

  static ngx_chain_t out = {0};

  out.buf = b;
  out.next = NULL;

  static int16_t id = 0;
  static int16_t randomNumber = 0;

  id           = 3776;
  randomNumber = 2019;

  static char json[128] = {0};
  snprintf(
    json,
    128,
    "{"
      "\"id\":%d,"
      "\"randomNumber\":%d"
    "}",
    id,
    randomNumber
  );

  r->headers_out.status = NGX_HTTP_OK;
  r->headers_out.content_length_n = strlen(json);

  b->pos      = (uint8_t*)json;
  b->last     = (uint8_t*)json + r->headers_out.content_length_n;
  b->memory   = 1;
  b->last_buf = 1;

  ngx_http_send_header(r);

  return ngx_http_output_filter(r, &out);
}

static char* ngx_http_test2query1(ngx_conf_t* cf, ngx_command_t* cmd, void* conf) {
  ngx_http_core_loc_conf_t* clcf;

  clcf = ngx_http_conf_get_module_loc_conf(cf, ngx_http_core_module);
  clcf->handler = ngx_http_test2query1_handler;

  return NGX_CONF_OK;
}
