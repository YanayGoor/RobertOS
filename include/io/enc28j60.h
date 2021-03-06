#ifndef ENC28J60_H
#define ENC28J60_H

#include <io/spi.h>

#define ENC28J60_PCRCEN	 (1 << 1)
#define ENC28J60_PPADEN	 (1 << 2)
#define ENC28J60_PHUGEEN (1 << 3)

#define ENC28J60_RX_ERR 1
#define ENC28J60_TX_ERR (1 << 1)

struct enc28j60_controller {
	const struct spi_module *module;
	const struct spi_slave *slave;
	/* cached state */
	int8_t selected_bank;
	uint16_t next_pkt_addr;
	uint16_t pkt_tx_status_addr;
	/* parameters */
	bool full_duplex;
	uint16_t max_frame_length;
	uint16_t rx_buff_start;
};

struct enc28j60_pkt_rx_hdr {
	uint16_t next_pkt_addr;
	uint16_t byte_count;
	uint8_t long_drop_event : 1;
	uint8_t reserved1 : 1;
	uint8_t carrier_event : 1;
	uint8_t reserved2 : 1;
	uint8_t crc_err : 1;
	uint8_t len_check_err : 1;
	uint8_t len_out_of_range : 1;
	uint8_t received_ok : 1;
	uint8_t multicast : 1;
	uint8_t broadcast : 1;
	uint8_t dribble_nibble : 1;
	uint8_t ctrl_frame : 1;
	uint8_t pause_ctrl_frame : 1;
	uint8_t unknown_ctrl_frame : 1;
	uint8_t vlan : 1;
	uint8_t zero : 1;
};

struct enc28j60_pkt_tx_status {
	uint16_t byte_count;
	uint8_t collision_count : 4;
	uint8_t crc_err : 1;
	uint8_t len_check_err : 1;
	uint8_t len_out_of_range : 1;
	uint8_t done : 1;
	uint8_t multicast : 1;
	uint8_t broadcast : 1;
	uint8_t deferred : 1;
	uint8_t accessivly_deferred : 1;
	uint8_t accessive_collision : 1;
	uint8_t late_collision : 1;
	uint8_t giant : 1;
	uint8_t underrun : 1;
	uint16_t bytes_transmitted;
	uint8_t ctrl_frame : 1;
	uint8_t pause_frame : 1;
	uint8_t backpressure_applied : 1;
	uint8_t vlan : 1;
	uint8_t zero : 3;
};

void enc28j60_init(struct enc28j60_controller *enc,
				   const struct spi_module *module,
				   const struct spi_slave *slave, bool full_duplex,
				   uint16_t max_frame_length, uint8_t rx_weight,
				   uint8_t tx_weight);
void enc28j60_reset(struct enc28j60_controller *enc);
int enc28j60_receive_packet(struct enc28j60_controller *enc,
							struct enc28j60_pkt_rx_hdr *header, uint8_t *buffer,
							size_t size);
uint16_t enc28j60_packets_received(struct enc28j60_controller *enc);
bool enc28j60_get_errors(struct enc28j60_controller *enc);
bool enc28j60_get_tx_busy(struct enc28j60_controller *enc);
void enc28j60_transmit_packet(struct enc28j60_controller *enc,
							  const uint8_t *buffer, size_t size,
							  uint8_t flags);
void enc28j60_last_transmitted_pkt_status(
	struct enc28j60_controller *enc, struct enc28j60_pkt_tx_status *status);

#endif // ENC28J60_H
