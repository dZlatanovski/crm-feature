<template>
  <q-page>
    <div class="q-pa-md q-mx-auto" style="max-width: 1400px">
      <h3 class="text-center">Customer orders</h3>
      <div>
        <q-table
          v-model:selected="selectedOrders"
          hide-pagination
          title="Orders"
          row-key="Id"
          selection="multiple"
          class="selected-orders-table"
          style="max-height: 500px"
          :pagination="{ rowsPerPage: 0 }"
          :columns="orderColumns"
          :rows="orders"
        >
          <template #bottom>
            <div class="flex justify-center full-width">
              <q-btn
                label="Calculate Follow-up"
                color="primary"
                @click="calculateFollowUpOrders"
              />
            </div>
          </template>
        </q-table>
      </div>
      <div class="q-mt-md">
        <q-table
          title=""
          row-key="Order ID"
          :columns="followUpOrdersColumns"
          :rows="followUpOrders"
        >
          <template #top>
            <div>
              <div class="text-h6">Follow-up Orders</div>
              Total price of all follow-up orders: {{ totalFollowUpPrice }}$
            </div>
          </template>
        </q-table>
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { api } from 'src/boot/axios';
import { onBeforeMount, ref, computed } from 'vue';
import { Order } from 'src/types/orders';

const orderColumns = [
  {
    name: 'Order ID',
    label: 'Order ID',
    field: 'Order ID',
    align: 'center',
  },
  {
    name: 'Customer ID',
    label: 'Customer ID',
    field: 'Customer ID',
    align: 'center',
  },
  {
    name: 'Customer Name',
    label: 'Customer Name',
    field: 'Customer Name',
    align: 'center',
  },
  {
    name: 'Product Name',
    label: 'Product Name',
    field: 'Product Name',
    align: 'center',
  },
  {
    name: 'Quantity',
    label: 'Quantity',
    field: 'Quantity',
    align: 'center',
  },
  {
    name: 'Total Price',
    label: 'Total Price',
    field: 'Total Price',
    align: 'center',
  },
  {
    name: 'Date',
    label: 'Date',
    field: 'Date',
    align: 'center',
  },
  {
    name: 'Id',
    label: 'Id',
    field: 'Id',
    align: 'center',
  },
];
const followUpOrdersColumns = [
  {
    name: 'Product Name',
    label: 'Product Name',
    field: 'Product Name',
    align: 'center',
  },
  {
    name: 'Quantity',
    label: 'Quantity',
    field: 'Quantity',
    align: 'center',
  },
  {
    name: 'Total Price',
    label: 'Total Price',
    field: 'Total Price',
    align: 'center',
  },
];

const orders = ref<Order[]>([]);
const selectedOrders = ref<Order[]>([]);
const followUpOrders = ref<
  Pick<Order, 'Product Name' | 'Quantity' | 'Total Price'>[]
>([]);

const totalFollowUpPrice = computed(() => {
  return followUpOrders.value.reduce((total, order) => {
    return total + Number(order['Total Price']);
  }, 0);
});

function calculateFollowUpOrders() {
  followUpOrders.value = [];
  const selectedOrdersMap: Record<string, Order[]> = {};
  for (const order of selectedOrders.value) {
    if (!selectedOrdersMap[order['Product Name']]) {
      selectedOrdersMap[order['Product Name']] = [];
    }
    selectedOrdersMap[order['Product Name']].push(order);
  }
  for (const productName in selectedOrdersMap) {
    let totalQuantity = 0;
    let totalPrice = 0;
    for (const order of selectedOrdersMap[productName]) {
      totalQuantity += Number(order['Quantity']);
      totalPrice += Number(order['Total Price']);
    }
    followUpOrders.value.push({
      'Product Name': productName,
      Quantity: String(totalQuantity),
      'Total Price': String(totalPrice),
    });
  }
}

onBeforeMount(async () => {
  const response = await api.get<Order[]>('/crm/orders');
  orders.value = response.data;
});
</script>

<style lang="scss">
.selected-orders-table {
  .q-table__top,
  thead tr:first-child th {
    background-color: $primary;
    color: #fff;
  }
  thead tr th {
    position: sticky;
    z-index: 1;
  }
  thead tr:first-child th {
    top: 0;
  }
}
</style>
