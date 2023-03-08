<script setup lang="ts">
import { NCard, NModal } from 'naive-ui'
import { computed, ref } from 'vue'
const show = computed({
  get() {
    return props.visible
  },
  set(visible: boolean) {
    emit('update:visible', visible)
  },
})

const loginForm = reactive({
  phone: '',
  captcha: ''
})
</script>

<template>
  <NModal v-model:show="show" :auto-focus="false">
    <NCard role="dialog" aria-modal="true" :bordered="false" style="width: 100%; max-width: 640px">
      <n-form ref="formRef" :model="loginForm">
        <n-form-item
          label="手机号"
          path="phone"
          :rule="{
            required: true,
            message: '请输入手机号',
            trigger: ['input', 'blur']
          }"
        >
          <n-input v-model:value="dynamicForm.name" clearable />
        </n-form-item>

        <n-form-item
          label="验证码"
          path="captcha"
          :rule="{
            required: true,
            message: '请输入验证码',
            trigger: ['input', 'blur']
          }"
        >
          <n-input v-model:value="item.hobby" clearable />
          <n-button style="margin-left: 12px" @click="removeItem(index)">
            获取验证码
          </n-button>
        </n-form-item>

        <n-form-item>
          <n-space>
            <n-button attr-type="button" @click="handleValidateClick">
              登录
            </n-button>
          </n-space>
        </n-form-item>
      </n-form>
    </NCard>
  </NModal>
</template>