<script setup lang='ts'>
import { computed, ref } from 'vue'
import { NButton, NFormItem, NInput, NModal, useMessage } from 'naive-ui'
import { fetchSms, fetchVerify } from '@/api'
import { useAuthStore } from '@/store'
import Icon403 from '@/icons/403.vue'

interface Props {
  visible: boolean
}
defineProps<Props>()

const phone = ref('')

const phoneValidationStatus = computed(() => {
  const flag = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(phone.value)
  if (flag)
    return undefined

  return 'error'
})
const phoneFeedback = computed(() => {
  const flag = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(phone.value)
  if (flag)
    return undefined

  return '请填写正确的手机号'
})
const authStore = useAuthStore()

const ms = useMessage()

const loading = ref(false)
// const token = ref('')

// const disabled = computed(() => !token.value.trim() || loading.value)

async function handleVerify() {
  let token = await fetchSms(phone.value)
  const secretKey = token.trim()

  if (!secretKey)
    return

  try {
    loading.value = true
    await fetchVerify(secretKey)
    authStore.setToken(secretKey)
    ms.success('success')
    window.location.reload()
  }
  catch (error: any) {
    ms.error(error.message ?? 'error')
    authStore.removeToken()
    token = ''
  }
  finally {
    loading.value = false
  }
}

// function handlePress(event: KeyboardEvent) {
//   if (event.key === 'Enter' && !event.shiftKey) {
//     event.preventDefault()
//     handleVerify()
//   }
// }
</script>

<template>
  <NModal :show="visible" style="width: 90%; max-width: 640px">
    <div class="p-10 bg-white rounded dark:bg-slate-800">
      <div class="space-y-4">
        <header class="space-y-2">
          <h2 class="text-2xl font-bold text-center text-slate-800 dark:text-neutral-200">
            403
          </h2>
          <p class="text-base text-center text-slate-500 dark:text-slate-500">
            {{ $t('common.unauthorizedTips') }}
          </p>
          <Icon403 class="w-[200px] m-auto" />
        </header>
        <NFormItem
          label="手机号：" :validation-status="phoneValidationStatus"
          :feedback="phoneFeedback"
        >
          <NInput v-model:value="phone" />
        </NFormItem>
        <!-- <n-form-item
            label="验证码"
            path="captcha"
            :rule="{
              required: true,
              message: '请输入验证码',
              trigger: ['input', 'blur']
            }"
          >
            <n-input v-model:value="loginForm.captcha" clearable />
            <n-button style="margin-left: 12px" @click="removeItem(index)">
              获取验证码
            </n-button>
          </n-form-item> -->

        <NButton
          block
          type="primary"
          :disabled="disabled"
          :loading="loading"
          @click="handleVerify"
        >
          {{ $t('common.verify') }}
        </NButton>
      </div>
    </div>
  </NModal>
</template>
